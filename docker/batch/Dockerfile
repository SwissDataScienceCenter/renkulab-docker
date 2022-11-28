# define build arguments
ARG RENKU_BASE=renku/renkulab-py:latest
ARG BASE_IMAGE=python:3.9-slim-buster

# define base images
FROM $RENKU_BASE as renku_base
FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# install dependencies
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y gcc git git-lfs nodejs libc6-dev && \
    apt-get purge && \
    apt-get clean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

# Install Renku python without pipx in a non-user location
COPY renku-requirements/requirements.txt /tmp/renku-requirements.txt
RUN python3 -m pip install virtualenv && \
    virtualenv --no-periodic-update /share/.renku && \
    . /share/.renku/bin/activate && \
    pip install --no-cache-dir -r /tmp/renku-requirements.txt && \
    deactivate && \
    mkdir /share/bin && \
    ln -s /share/.renku/bin/renku /share/bin

ENV PATH /share/bin:$PATH

# inject entrypoint.sh
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
