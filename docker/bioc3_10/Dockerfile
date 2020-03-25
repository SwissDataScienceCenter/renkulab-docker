ARG RELEASE=RELEASE_3_10
FROM bioconductor/bioconductor_docker:${RELEASE}
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

# install miniconda (https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile)
RUN apt-get update --fix-missing && \
    apt-get install -yq --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        gnupg \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        wget \
        vim && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install git-lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    apt-get install git-lfs

WORKDIR /tmp
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ${CONDA_PATH} && \
    rm ~/miniconda.sh && \
    ${CONDA_PATH}/bin/conda clean -tipsy && \
    ln -s ${CONDA_PATH}/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    ${CONDA_PATH}/bin/conda config --system --append channels conda-forge && \
    ${CONDA_PATH}/bin/conda config --system --set auto_update_conda false && \
    find ${CONDA_PATH}/ -follow -type f -name '*.a' -delete && \
    find ${CONDA_PATH}/ -follow -type f -name '*.js.map' -delete && \
    ${CONDA_PATH}/bin/conda clean -afy

# set permissions in the conda directory to be editable by NB_USER
ADD fix-permissions.sh /usr/local/bin
RUN fix-permissions.sh ${CONDA_PATH}

USER ${NB_USER}

# set up conda in the NB_USER environment
RUN echo ". ${CONDA_PATH}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# install the jupyter stack
ARG JUPYTERHUB_VERSION=1.1.0

RUN ${CONDA_PATH}/bin/conda install --quiet --yes \
    'notebook=6.0.0' \
    "jupyterhub=${JUPYTERHUB_VERSION}" \
    'jupyterlab=1.2.6' && \
    ${CONDA_PATH}/bin/conda install -c conda-forge 'nodejs>=6.11.5' && \
    ${CONDA_PATH}/bin/conda install --quiet --yes conda-build && \
    ${CONDA_PATH}/bin/conda build purge-all && \
    npm cache clean --force

RUN jupyter notebook --generate-config && \
    rm -rf ${CONDA_PATH}/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    pip install -U --no-cache-dir pip wheel


# install jupyterlab, git extension
RUN python3 -m pip install -U pip && \
    jupyter labextension update @jupyterlab/hub-extension --no-build && \
    jupyter labextension install @jupyterlab/git --no-build && \
    jupyter labextension list && \
    pip install "jupyter-rsession-proxy==1.1" && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter lab build

# install IRKernel
RUN R --quiet -e "install.packages('IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${CONDA_PATH}')"

# install renku
# the RENKU_PIP_SPEC should be e.g. "renku==0.5.2"
ARG RENKU_PIP_SPEC="renku"
RUN python3 -m pip install "pipx>=0.15.0.0" && \
    pipx install ${RENKU_PIP_SPEC} --pip-args="--pre" && \
    pipx inject renku sentry-sdk && \
    pipx ensurepath

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]
CMD [ "jupyterhub-singleuser" ]

WORKDIR ${HOME}
