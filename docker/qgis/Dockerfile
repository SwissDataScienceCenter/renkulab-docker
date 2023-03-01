# For finding latest versions of the base image see
# https://github.com/SwissDataScienceCenter/renkulab-docker
ARG BASE_IMAGE=renku/renkulab-vnc:latest
FROM ${BASE_IMAGE}

USER root
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# Install QGIS
RUN apt-get update \
    && apt-get install -y -q --no-install-recommends \
        gnupg \
        software-properties-common \
        libqt5gui5 \
    && wget -qO - https://qgis.org/downloads/qgis-2022.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import \
    && chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg \
    && add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main" \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
        qgis \
    && apt-get autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Fixes downstream bug with libQt5Core.so.5
RUN strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

# Add desktop icon for QGIS
COPY --chown=root:root qgis.desktop /home/jovyan/Desktop/
RUN chmod +x /home/jovyan/Desktop/qgis.desktop

USER ${NB_USER}

# install the python dependencies
RUN mamba install -y -c conda-forge qgis
