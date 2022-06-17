# define build arguments
ARG RENKU_BASE=renku/renkulab-py:latest
ARG BASE_IMAGE=python:3.9-slim-buster
ARG RENKU_VERSION=1.4.0

# define base images
FROM $RENKU_BASE as renku_base
FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

# install dependencies
RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update -y && \
    apt-get install -y gcc git git-lfs nodejs && \
    apt-get purge && \
    apt-get clean && \
    apt autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

# Install Renku python without pipx in a non-user location
ARG RENKU_VERSION
RUN python3 -m pip install --no-cache pipenv
RUN virtualenv --pip 21.3.1 --setuptools 57.5.0 --wheel 0.36.2  --no-periodic-update /share/.renku && \
    . /share/.renku/bin/activate && \
    pip install --no-cache renku==$RENKU_VERSION sentry-sdk && \
    deactivate && \
    mkdir /share/bin && \
    ln -s /share/.renku/bin/renku /share/bin

ENV PATH /share/bin:$PATH

# inject entrypoint.sh
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
