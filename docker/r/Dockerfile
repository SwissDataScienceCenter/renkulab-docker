ARG RVERSION=3.6.3
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

# install conda
WORKDIR /tmp
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ${CONDA_PATH} && \
    rm ~/miniconda.sh && \
    ln -s ${CONDA_PATH}/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    ${CONDA_PATH}/bin/conda config --system --append channels conda-forge && \
    ${CONDA_PATH}/bin/conda config --system --set auto_update_conda false && \
    find ${CONDA_PATH}/ -follow -type f -name '*.a' -delete && \
    find ${CONDA_PATH}/ -follow -type f -name '*.js.map' -delete && \
    ${CONDA_PATH}/bin/conda clean -afy

# set permissions in the conda directory to be editable by NB_USER
ADD fix-permissions.sh /usr/local/bin
RUN fix-permissions.sh ${CONDA_PATH} && \
    fix-permissions.sh /usr/local/lib/R

USER ${NB_USER}

# set up conda in the NB_USER environment
RUN echo ". ${CONDA_PATH}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# install the jupyter stack
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -U --no-cache-dir pip wheel && \
    python3 -m pip install --quiet --no-cache-dir -r /tmp/requirements.txt && \
    conda install --quiet --yes \
    'jupyterlab=2.0.1' \
    conda-build && \
    conda build purge-all  && \
    jupyter labextension update @jupyterlab/hub-extension --no-build && \
    jupyter labextension install --no-build @jupyterlab/toc \
                                            jupyterlab-topbar-extension \
                                            jupyterlab-system-monitor && \
    jupyter lab build && \
    npm cache clean --force && \
    jupyter labextension list && \
    jupyter notebook --generate-config && \
    rm -rf ${CONDA_PATH}/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn

# install IRKernel
RUN R --quiet -e "install.packages('IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${CONDA_PATH}')"

# install renku
# the RENKU_PIP_SPEC should be e.g. "renku==0.5.2"
ARG RENKU_PIP_SPEC="renku"
RUN pipx install ${RENKU_PIP_SPEC} --pip-args="--pre" && \
    pipx inject renku sentry-sdk
#RUN  pipx ensurepath # this doesn't seem to be adding to the path :(
RUN echo "export PATH=$PATH:/home/$NB_USER/.local/bin" >> ~/.bashrc

# configure powerline
COPY powerline.bashrc /tmp/powerline.bashrc
COPY powerline.config /tmp/powerline.config

RUN cat /tmp/powerline.bashrc >> ~/.bashrc && \
    pip install powerline-shell && \
    mkdir -p ~/.config/powerline-shell/ && \
    cat /tmp/powerline.config >> ~/.config/powerline-shell/config.json && \
    echo "source ~/.bashrc" >> ~/.bash_profile

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]
CMD [ "jupyterhub-singleuser" ]

WORKDIR ${HOME}
