# Build as renku/singleuser
# Run with the RenkuKubeSpawner via JupyterHub

ARG JUPYTERHUB_VERSION=0.9.2
ARG BASE_IMAGE=jupyterhub/singleuser:$JUPYTERHUB_VERSION
FROM $BASE_IMAGE as base

# Renku wheel builder
FROM python:3.6-alpine as renku
ARG RENKU_VERSION=master

ENV BUILD_DEPS "alpine-sdk g++ gcc linux-headers libxslt-dev zeromq-dev"

RUN apk add --no-cache git && \
    pip install --no-cache --upgrade pip && \
    apk add --no-cache $BUILD_DEPS && \
    pip wheel --wheel-dir /wheels git+https://github.com/SwissDataScienceCenter/renku-python@$RENKU_VERSION#egg=renku && \
    apk del --purge $BUILD_DEPS

# build singleuser image
FROM base

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root
# Copied from jupyter-minimal-notebook
# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    curl \
    git \
    gnupg \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    nano \
    netcat \
    python-dev \
    unzip \
    vim \
    musl-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# link the musl library needed by psutil
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

# install git-lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && sudo apt-get install git-lfs=2.4.2

# switch to the notebook user
USER $NB_USER

# install jupyterlab, papermill, git extension and renku-jupyterlab-ts
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -U pip && \
    pip install -r /tmp/requirements.txt && \
    jupyter labextension update @jupyterlab/hub-extension --no-build && \
    jupyter labextension install @jupyterlab/git && \
    jupyter labextension install renku-jupyterlab-ts --no-build && \
    jupyter lab build && \
    jupyter labextension list && \
    pip install jupyterlab-git==0.5.0 && \
    jupyter serverextension enable --py jupyterlab_git

# fix https://github.com/SwissDataScienceCenter/renku-jupyter/issues/14
RUN conda install gxx_linux-64

# install renku-python
COPY --from=renku /wheels /wheels

ENV RENKU_DISABLE_VERSION_CHECK 1

RUN pip install pipx && \
    pipx install --spec /wheels/renku*.whl renku && \
    pipx ensurepath

COPY git-config.bashrc /home/$NB_USER/
RUN cat /home/$NB_USER/git-config.bashrc >> /home/$NB_USER/.bashrc && rm /home/$NB_USER/git-config.bashrc

# Add user `jovyan` to sudoers (passwordless)
USER root
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm -rf /wheels
USER $NB_USER

CMD '/usr/local/bin/start-singleuser.sh'
