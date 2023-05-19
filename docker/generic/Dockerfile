# define build arguments
ARG RENKU_BASE=renku/renkulab-py:latest
ARG BASE_IMAGE=python:3-slim-bullseye
ARG NB_USER=jovyan

# define base images
FROM ${RENKU_BASE} as renku_base
FROM $BASE_IMAGE
ARG NB_USER

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

ENV NB_UID 1000
ENV NB_GID 100
ENV VENV_DIR /srv/venv
ENV HOME /home/${NB_USER}
ENV SHELL bash
ENV CONDA_PATH /opt/conda
ENV NB_USER=${NB_USER}

# install dependencies
RUN apt-get update --fix-missing && \
    apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    gpg-agent \
    gnupg \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    rclone \
    tini \
    wget \
    vim && \
    apt-get purge && \
    apt-get clean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -P /tmp && \
    tar -zxvf /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -C /tmp && \
    /tmp/git-lfs-3.3.0/install.sh && \
    rm -rf /tmp/git-lfs*

# handle the NB_USER setup
RUN id -u ${NB_USER} || useradd ${NB_USER} && \
    usermod -a -G jovyan ${NB_USER}

# prepend conda to PATH
ENV PATH ${CONDA_PATH}/bin:$PATH

# inject the renku-jupyter stack
COPY --from=renku_base /opt/conda /opt/conda
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
COPY --from=renku_base --chown=1000:100 \
    /home/jovyan/ /home/${NB_USER}/

WORKDIR $HOME
USER $NB_USER
