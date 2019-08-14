ARG RVERSION=3.6.1
FROM rocker/rstudio:${RVERSION}
LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

# The initial setup is based on https://github.com/rocker-org/binder

USER root

ENV NB_USER rstudio
ENV NB_UID 1000
ENV VENV_DIR /srv/venv
ENV HOME /home/${NB_USER}
ENV SHELL bash

# Set ENV for all programs...
ENV PATH ${VENV_DIR}/bin:$PATH
# And set ENV for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron && \
    echo "PATH=${PATH}" >> /etc/profile.d/set_path.sh

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib


RUN apt-get update && \
    apt-get -y install \
                       build-essential \
                       checkinstall \
                       curl \
                       gnupg \
                       libbz2-dev \
                       libc6-dev \
                       libffi-dev \
                       libgdbm-dev \
                       libncursesw5-dev \
                       libreadline-gplv2-dev \
                       libsqlite3-dev \
                       libssl-dev \
                       tk-dev \
                       zlib1g-dev && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    apt-get install git-lfs

# install python 3.7
WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz && \
    tar xzf Python-3.7.4.tgz
WORKDIR /usr/src/Python-3.7.4
RUN ./configure --enable-optimizations && \
    make install

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Create a venv dir owned by unprivileged user & set up notebook in it
# This allows non-root to install python libraries if required
RUN mkdir -p ${VENV_DIR} && chown -R ${NB_USER} ${VENV_DIR}

USER ${NB_USER}

# install jupyter dependencies
ARG JUPYTERHUB_VERSION=0.9.6
RUN python3 -m venv ${VENV_DIR} && \
    pip3 install -U --no-cache-dir pip wheel && \
    pip3 install --no-cache-dir \
         jupyter-rsession-proxy \
         jupyterlab==1.0.0 \
         jupyterhub==${JUPYTERHUB_VERSION}

# install IRKernel and renv
RUN R --quiet -e "install.packages('IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${VENV_DIR}')" && \
    R --quiet -e "install.packages('remotes')" && \
    R --quiet -e "remotes::install_github('rstudio/renv')"

# install renku
# the RENKU_PIP_SPEC should be e.g. "--spec renku==0.5.2"
ARG RENKU_PIP_SPEC=""
RUN pip3 install --no-cache-dir pipx && \
    pipx install ${RENKU_PIP_SPEC} --pip-args="--pre" renku && \
    pipx inject renku sentry-sdk && \
    pipx ensurepath

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]
CMD [ "jupyterhub-singleuser" ]

WORKDIR ${HOME}
