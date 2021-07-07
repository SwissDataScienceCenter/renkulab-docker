# define build arguments
ARG RENKU_BASE=renku/renkulab-py:latest
ARG BASE_IMAGE=python:3.8-slim

# define base images
FROM $RENKU_BASE as renku_base
FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

# install dependencies
RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update -y && \
    apt-get install -y git git-lfs nodejs && \
    apt-get purge && \
    apt-get clean && \
    apt autoremove --yes && \
    rm -rf /var/lib/apt/lists/* 

RUN pip install pipx

# override default locations of pipx and app installation
ENV PIPX_BIN_DIR /share/bin
ENV PIPX_HOME /share/pipx
ENV PATH /share/bin:$PATH

# install renku-python
RUN pipx install --pip-args="--no-cache" renku

# inject entrypoint.sh
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]