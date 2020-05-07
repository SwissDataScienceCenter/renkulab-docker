# define build arguments
ARG RENKU_BASE=renku/renkulab-py3.7:latest
ARG BASE_IMAGE=python:slim-buster
ARG NB_USER=jovyan

# define base images
FROM ${RENKU_BASE} as renku_base
FROM $BASE_IMAGE
ARG NB_USER

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root

ENV NB_UID 1000
ENV NB_GID 1000
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
    gpg-agent && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -yq --no-install-recommends \
    git-lfs \
    gnupg \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    wget \
    vim && \
    apt-get purge && \
    apt-get clean && \
    apt autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

# handle the NB_USER setup
RUN id -u ${NB_USER} || useradd ${NB_USER} && \
    usermod -a -G jovyan ${NB_USER}

# prepend conda to PATH
ENV PATH ${CONDA_PATH}/bin:$PATH

# inject the renku-jupyter stack
COPY --from=renku_base /opt/conda /opt/conda
COPY --from=renku_base --chown=1000:1000 \
    /home/jovyan/ /home/${NB_USER}/

WORKDIR $HOME
USER $NB_USER