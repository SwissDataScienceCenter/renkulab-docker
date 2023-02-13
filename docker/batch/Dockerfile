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
    apt-get install --no-install-recommends -y curl wget git && \
    apt-get purge && \
    apt-get clean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -P /tmp && \
    tar -zxvf /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -C /tmp && \
    /tmp/git-lfs-3.3.0/install.sh && \
    rm -rf /tmp/git-lfs*

# Install Renku from base python image

COPY --from=renku_base /home/jovyan/.renku /share/.renku
COPY --from=renku_base /opt/conda /opt/conda

RUN mkdir /share/bin && \
    ln -s /share/.renku/venv/bin/renku /share/bin && \
    rm -rf /share/.renku/venv/bin/__pycache__ && \
    sed -i 's/\/home\/jovyan/\/share/g' /share/.renku/venv/bin/*

ENV PATH /share/bin:$PATH

# inject entrypoint.sh
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
