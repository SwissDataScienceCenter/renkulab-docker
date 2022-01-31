# Copyright 2020 The MathWorks, Inc.

# Argument shared across multi-stage build to hold location of installed MATLAB 
ARG BASE_ML_INSTALL_LOC=/tmp/matlab-install-location

# For finding latest versions of the base image see
# https://github.com/SwissDataScienceCenter/renkulab-docker
ARG RENKU_BASE_IMAGE=renku/renkulab-py:latest

# Replace "mathworks/matlab" with any Docker image that contains MATLAB
# MATLAB should be available on the path in the Docker image
FROM mathworks/matlab AS matlab-install-stage
ARG BASE_ML_INSTALL_LOC

# Run code to locate a MATLAB install in the base image and softlink
# to BASE_ML_INSTALL_LOC for a latter stage to copy 
RUN export ML_INSTALL_LOC=$(which matlab) \
    && if [ ! -z "$ML_INSTALL_LOC" ]; then \
        ML_INSTALL_LOC=$(dirname $(dirname $(readlink -f ${ML_INSTALL_LOC}))); \
        echo "soft linking: " $ML_INSTALL_LOC " to" ${BASE_ML_INSTALL_LOC}; \
        ln -s ${ML_INSTALL_LOC} ${BASE_ML_INSTALL_LOC}; \
    elif [ $BASE_ML_INSTALL_LOC = '/tmp/matlab-install-location' ]; then \
        echo "MATLAB was not found in your image."; exit 1; \
    else \
        echo "Proceeding with user provided path to MATLAB installation: ${BASE_ML_INSTALL_LOC}"; \
    fi

FROM ${RENKU_BASE_IMAGE}
# Use Renku instead of the base notebook
# FROM jupyter/base-notebook
ARG BASE_ML_INSTALL_LOC

# Switch to root user
USER root

# Copy MATLAB install from supplied Docker image
COPY --from=matlab-install-stage ${BASE_ML_INSTALL_LOC} /usr/local/MATLAB

# Put MATLAB on the PATH
RUN ln -s /usr/local/MATLAB/bin/matlab /usr/local/bin/matlab

# Install MATLAB dependencies
# Reference: https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps
# The following are the dependencies for R2021a
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo-gobject2 \
        libcairo2 \
        libcrypt1 \
        libcups2 \
        libdbus-1-3 \
        libfontconfig1 \
        libgdk-pixbuf2.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer1.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libodbc1 \
        libpam0g \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpangoft2-1.0-0 \
        libpython2.7 \
        libpython3.8 \
        libselinux1 \
        libsm6 \
        libsndfile1 \
        libuuid1 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxft2 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        libxt6 \
        libxtst6 \
        libxxf86vm1 \
        locales \
        locales-all \
        make \
        net-tools \
        procps \
        sudo \
        tzdata \
        unzip \
        zlib1g \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# Install jupyter-matlab-proxy dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install --yes \
        xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Uncomment and adapt if code is to be included in the image
# COPY src /code/src

# Uncomment and adapt if your R or python packages require extra linux (ubuntu) software
# e.g. the following installs apt-utils and vim; each pkg on its own line, all lines
# except for the last end with backslash '\' to continue the RUN line
#
# USER root
# RUN apt-get update && \
#    apt-get install -y --no-install-recommends \
#    apt-utils \
#    vim

USER ${NB_USER}

# install the python dependencies
COPY requirements.txt environment.yml /tmp/
RUN conda env update -q -f /tmp/environment.yml && \
    /opt/conda/bin/pip install -r /tmp/requirements.txt && \
    conda clean -y --all && \
    conda env export -n "root"

# RENKU_VERSION determines the version of the renku CLI
# that will be used in this image. To find the latest version,
# visit https://pypi.org/project/renku/#history.
ARG RENKU_VERSION={{ __renku_version__ | default("0.16.2") }}

########################################################
# Do not edit this section and do not add anything below

# Install renku from pypi or from github if it's a dev version
RUN if [ -n "$RENKU_VERSION" ] ; then \
        source .renku/venv/bin/activate ; \
        currentversion=$(renku --version) ; \
        if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
            pip uninstall renku -y ; \
            gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(rc[[:digit:]]\+\)*\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\4/p") ; \
            if [ -n "$gitversion" ] ; then \
                pip install --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
            else \
                pip install --force renku==${RENKU_VERSION} ;\
            fi \
        fi \
    fi

########################################################
