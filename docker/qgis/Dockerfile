# For finding latest versions of the base image see
# https://github.com/SwissDataScienceCenter/renkulab-docker
ARG BASE_IMAGE=renku/renkulab-vnc:latest
FROM ${BASE_IMAGE}

USER root

# Install qGIS
RUN apt-get update \
    && apt-get install -y -q --no-install-recommends \
        gnupg \
        software-properties-common \
        libqt5gui5 \
    && apt-get autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN wget -qO - https://qgis.org/downloads/qgis-2021.gpg.key | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import \
    && chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg

RUN add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main"

# Fixes a bug https://github.com/qgis/QGIS/issues/35649 and removes qgis-providers which may be a problem
# RUN apt-get remove --auto-remove libproj15 libproj-dev qgis-providers

# Fixes downstream bug with libQt5Core.so.5
RUN strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

RUN apt-get update \
    && apt-get install -y -q --no-install-recommends \
        qgis 
        
COPY --chown=root:root qgis.desktop /home/jovyan/Desktop/
RUN chmod +x /home/jovyan/Desktop/qgis.desktop

USER ${NB_USER}

# install the python dependencies
RUN conda install -c conda-forge qgis
