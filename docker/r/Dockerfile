# define build arguments
ARG RENKU_BASE=renku/renkulab:renku-py3.7-b1b58a1
ARG RVERSION=3.6.3

# define base images
FROM ${RENKU_BASE} as renku_base
FROM rocker/verse:${RVERSION}

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root

ENV NB_USER rstudio
ENV NB_UID 1000
ENV NB_GID 1000
ENV VENV_DIR /srv/venv
ENV HOME /home/${NB_USER}
ENV SHELL bash
ENV CONDA_PATH /opt/conda

# prepend conda to PATH
ENV PATH ${CONDA_PATH}/bin:$PATH
# And set PATH for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron && \
    echo "PATH=${PATH}" >> /etc/profile.d/set_path.sh

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# install dependencies
RUN apt-get update --fix-missing && \
    apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update --fix-missing && \
    apt-get install -yq --no-install-recommends \
    git-lfs \
    gnupg \
    nodejs \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    wget \
    vim && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# inject the renku-jupyter stack
COPY --from=renku_base /opt/conda /opt/conda
COPY --from=renku_base --chown=rstudio:rstudio \
    /home/jovyan/ /home/rstudio/

# set permissions in the conda directory to be editable by NB_USER
ADD fix-permissions.sh /usr/local/bin
RUN fix-permissions.sh ${CONDA_PATH} && \
    fix-permissions.sh /usr/local/lib/R

USER ${NB_USER}

# set up conda in the NB_USER environment
RUN echo ". ${CONDA_PATH}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN pip install "jupyter-rsession-proxy==1.1"

# install IRKernel
RUN R --quiet -e "install.packages('IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${CONDA_PATH}')"

RUN  echo "source ~/.bashrc" >> ~/.bash_profile

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]
CMD [ "jupyterhub-singleuser" ]

WORKDIR ${HOME}
