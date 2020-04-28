# Run with the RenkuKubeSpawner via JupyterHub
ARG BASE_IMAGE=jupyter/base-notebook:8fd7ada2a374
FROM $BASE_IMAGE as base

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root

# Install additional dependencies and nice-to-have packages
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && apt-get install -yq --no-install-recommends \
    git \
    git-lfs=2.8.0 \
    gnupg \
    graphviz \
    less \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    musl-dev \
    nano \
    netcat \
    python-dev \
    unzip \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

# Add a new group with id 1000 and arbitrary name
# Note: this is to standardize groups between the R and jupyter images
RUN groupadd -g 1000 jovyan

# switch to the notebook user
USER $NB_USER

# install jupyterlab, papermill, git extension and renku-jupyterlab-ts
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache -U pip && \
    python3 -m pip install --no-cache -r /tmp/requirements.txt && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor && \
    jupyter lab build && \
    jupyter labextension list && \
    npm cache clean --force && \
    rm -rf /home/${NB_USER}/.cache

# fix https://github.com/SwissDataScienceCenter/renku-jupyter/issues/14
RUN conda install gxx_linux-64 && \
    conda clean --all -f -y

# install renku-python
ENV RENKU_DISABLE_VERSION_CHECK 1

ARG RENKU_PIP_SPEC="renku"
RUN pipx install ${RENKU_PIP_SPEC} --pip-args="--pre --no-cache" && \
    pipx inject --pip-args="--no-cache" renku sentry-sdk && \
    sh -c "pipx ensurepath"

# configure git
COPY git-config.bashrc /home/$NB_USER/
RUN cat /home/$NB_USER/git-config.bashrc >> /home/$NB_USER/.bashrc && rm /home/$NB_USER/git-config.bashrc

# configure powerline
COPY --chown=1000:1000 powerline.bashrc /tmp/powerline.bashrc
COPY --chown=1000:1000 powerline.config /home/${NB_USER}/.config/powerline-shell/config.json

RUN cat /tmp/powerline.bashrc >> ~/.bashrc && rm /tmp/powerline.bashrc

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]

CMD '/usr/local/bin/start-singleuser.sh'
