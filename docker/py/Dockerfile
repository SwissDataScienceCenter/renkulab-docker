ARG BASE_IMAGE=jupyter/base-notebook:python-3.10

FROM ${BASE_IMAGE} as builder

USER root
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# remove the nodejs pin if needed - see https://github.com/jupyter/docker-stacks/issues/1990
RUN sed -i '/nodejs/d' /opt/conda/conda-meta/pinned

# switch to the notebook user
USER $NB_USER
# install jupyterlab, papermill, git extension and renku-jupyterlab-ts
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir -U pip && \
    python3 -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    jupyter labextension disable "@jupyterlab/apputils-extension:announcements" && \
    rm -rf "/home/${NB_USER}/.cache"

# jupyter sets channel priority to strict which often causes very long error messages
RUN mamba config --system --set channel_priority flexible && \
    mamba clean --all -f -y

COPY renku-requirements/requirements.txt /tmp/renku-requirements.txt

RUN mkdir -p "$HOME/.renku/bin" && \
    virtualenv --no-periodic-update "$HOME/.renku/venv" && \
    source "$HOME/.renku/venv/bin/activate" && \
    pip install --no-cache-dir -r /tmp/renku-requirements.txt && \
    deactivate

FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# Install additional dependencies and nice-to-have packages
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    curl \
    git \
    gnupg \
    graphviz \
    jq \
    less \
    libsm6 \
    libxext-dev \
    libxrender1 \
    libyaml-0-2 \
    libyaml-dev \
    lmodern \
    musl-dev \
    nano \
    netcat \
    rclone \
    unzip \
    vim \
    openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1 && \
    wget -q https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -P /tmp && \
    wget -q  https://github.com/justjanne/powerline-go/releases/download/v1.24/powerline-go-linux-"$(dpkg --print-architecture)" -O /usr/local/bin/powerline-shell && \
    chmod a+x /usr/local/bin/powerline-shell && \
    tar -zxvf /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -C /tmp && \
    /tmp/git-lfs-3.3.0/install.sh && \
    rm -rf /tmp/git-lfs*

USER $NB_USER

# setup sshd
RUN mkdir -p "$HOME/.ssh" && \
    touch "$HOME/.ssh/authorized_keys" && \
    chmod u=rw,g=,o= "$HOME/.ssh/authorized_keys"

# configure bash and shell prompt
ENV PATH=$HOME/.local/bin:$PATH:$HOME/.renku/bin
COPY --chown=1000:100 bashrc /renku/
RUN cat "/renku/bashrc" >> "${HOME}/.bashrc" 

COPY entrypoint.sh /entrypoint.sh

# Setup ssh keys
USER root
RUN mkdir -p /opt/ssh/sshd_config.d /opt/ssh/ssh_host_keys /opt/ssh/pid && \
    ssh-keygen -q -N "" -t dsa -f /opt/ssh/ssh_host_keys/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -b 4096 -f /opt/ssh/ssh_host_keys/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t ecdsa -f /opt/ssh/ssh_host_keys/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t ed25519 -f /opt/ssh/ssh_host_keys/ssh_host_ed25519_key

COPY sshd_config /opt/ssh/sshd_config

RUN chown -R 0:100 /opt/ssh/ && \
    chmod -R u=rwX,g=rX,o= /opt/ssh && \
    chmod -R u=rwX,g=rwX,o= /opt/ssh/pid

ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]

CMD [ "jupyter", "server", "--ip", "0.0.0.0" ]

USER $NB_USER
COPY --chown=1000:100 --from=builder /opt/conda /opt/conda
COPY --chown=1000:100 --from=builder "$HOME/.renku" "$HOME/.renku"
RUN ln -s "$HOME/.renku/venv/bin/renku" "$HOME/.renku/bin/renku" && \
    ln -s "$HOME/.renku/venv/bin/_toil_worker" "$HOME/.renku/bin/"
ARG CONDA_ENVS_DIRS=/opt/conda/envs
ENV CONDA_ENVS_DIRS=${CONDA_ENVS_DIRS}
