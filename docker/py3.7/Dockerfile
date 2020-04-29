# Build as renku/singleuser
# Run with the RenkuKubeSpawner via JupyterHub

ARG JUPYTERHUB_VERSION=1.2
ARG BASE_IMAGE=jupyterhub/singleuser:$JUPYTERHUB_VERSION
FROM $BASE_IMAGE as base

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root
# Copied from jupyter-minimal-notebook
# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    curl \
    git \
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
    vim \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# link the musl library needed by psutil
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

# install git-lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && sudo apt-get install git-lfs=2.8.0

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Add a new group with id 1000 and arbitrary name
# Note: this is to standardize groups between the R and jupyter images
RUN groupadd -g 1000 jovyan

# switch to the notebook user
USER $NB_USER

# install jupyterlab, papermill, git extension and renku-jupyterlab-ts
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -U pip && \
    pip install --no-cache -r /tmp/requirements.txt && \
    jupyter labextension update @jupyterlab/hub-extension --no-build && \
    jupyter labextension install @jupyterlab/git --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor && \
    jupyter labextension list && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter lab build && \
    npm cache clean --force && \
    rm -rf /home/${NB_USER}/.cache

# fix https://github.com/SwissDataScienceCenter/renku-jupyter/issues/14
RUN conda install gxx_linux-64

# install renku-python
ENV RENKU_DISABLE_VERSION_CHECK 1

RUN python3 -m pip install "pipx>=0.15.0.0"
ARG RENKU_PIP_SPEC="renku"
RUN pipx install ${RENKU_PIP_SPEC} --pip-args="--pre" && \
    pipx inject renku sentry-sdk && \
    pipx ensurepath

# configure git
COPY git-config.bashrc /home/$NB_USER/
RUN cat /home/$NB_USER/git-config.bashrc >> /home/$NB_USER/.bashrc && rm /home/$NB_USER/git-config.bashrc

# configure powerline
COPY powerline.bashrc /tmp/powerline.bashrc
COPY powerline.config /tmp/powerline.config

RUN cat /tmp/powerline.bashrc >> ~/.bashrc && \
    pip install powerline-shell && \
    mkdir -p ~/.config/powerline-shell/ && \
    cat /tmp/powerline.config >> ~/.config/powerline-shell/config.json

# Add user `jovyan` to sudoers (passwordless)
USER root
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm -rf /wheels
USER $NB_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]

CMD '/usr/local/bin/start-singleuser.sh'
