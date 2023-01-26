ARG BASE_IMAGE=jupyter/base-notebook:lab-3.4.0
FROM $BASE_IMAGE as base

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# Install additional dependencies and nice-to-have packages
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && apt-get install -yq --no-install-recommends \
    git \
    git-lfs=3.2.0 \
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
    unzip \
    vim \
    openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

# Setup ssh keys
RUN mkdir -p /opt/ssh/sshd_config.d /opt/ssh/ssh_host_keys && \
    ssh-keygen -q -N "" -t dsa -f /opt/ssh/ssh_host_keys/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -b 4096 -f /opt/ssh/ssh_host_keys/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t ecdsa -f /opt/ssh/ssh_host_keys/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t ed25519 -f /opt/ssh/ssh_host_keys/ssh_host_ed25519_key


COPY sshd_config /opt/ssh/sshd_config

RUN chown -R 0:100 /opt/ssh/ && \
    chmod -R u=rwX,g=rX,o= /opt/ssh

# switch to the notebook user
USER $NB_USER

# install jupyterlab, papermill, git extension and renku-jupyterlab-ts
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir -U pip && \
    python3 -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    # jupyter lab build && \
    # jupyter labextension list && \
    # npm cache clean --force && \
    rm -rf "/home/${NB_USER}/.cache"

# fix https://github.com/SwissDataScienceCenter/renku-jupyter/issues/14
RUN conda install gxx_linux-64 && \
    # jupyter sets channel priority to strict which often causes very long error messages
    conda config --system --set channel_priority flexible && \
    conda clean --all -f -y

# setup sshd
RUN mkdir -p "$HOME/.ssh" && \
    touch "$HOME/.ssh/authorized_keys" && \
    chmod u=rw,g=,o= "$HOME/.ssh/authorized_keys"

# install renku-python
ENV RENKU_DISABLE_VERSION_CHECK 1

ENV PATH=$HOME/.local/bin:$PATH:$HOME/.renku/bin

COPY renku-requirements/requirements.txt /tmp/renku-requirements.txt

RUN mkdir -p "$HOME/.renku/bin" && \
    virtualenv --no-periodic-update "$HOME/.renku/venv" && \
    source "$HOME/.renku/venv/bin/activate" && \
    pip install --no-cache-dir -r /tmp/renku-requirements.txt && \
    deactivate && \
    ln -s "$HOME/.renku/venv/bin/renku" "$HOME/.renku/bin/renku" && \
    echo $'if (tty -s); then\n\
    source ~/.renku/venv/bin/activate\n\
    export PATH=/opt/conda/bin:$PATH\n\
fi\n\
'>> "/home/${NB_USER}/.bashrc"

# configure git
COPY git-config.bashrc /home/$NB_USER/
RUN cat "/home/$NB_USER/git-config.bashrc" >> "/home/$NB_USER/.bashrc" && rm "/home/$NB_USER/git-config.bashrc"

# configure powerline
COPY --chown=1000:100 powerline.bashrc /tmp/powerline.bashrc
COPY --chown=1000:100 powerline.config /home/${NB_USER}/.config/powerline-shell/config.json

RUN cat /tmp/powerline.bashrc >> ~/.bashrc && rm /tmp/powerline.bashrc

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]

CMD [ "/usr/local/bin/start-singleuser.sh" ]
