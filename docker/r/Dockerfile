# define build arguments
ARG RENKU_BASE=renku/renkulab-py:latest
ARG BASE_IMAGE=rocker/verse:devel

# define base images
FROM $RENKU_BASE as renku_base
FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root

ENV NB_USER rstudio
ENV NB_UID 1000
ENV NB_GID 100
ENV VENV_DIR /srv/venv
ENV HOME /home/${NB_USER}
ENV SHELL bash
ENV CONDA_PATH /opt/conda
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# prepend conda and local/bin to PATH
ENV PATH ${HOME}/.local/bin:${CONDA_PATH}/bin:${HOME}/.renku/bin:$PATH

# And set PATH for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron.site && \
    echo "PATH=${PATH}" >> /etc/profile.d/set_path.sh && \
    echo "RENKU_DISABLE_VERSION_CHECK=1" >> /usr/local/lib/R/etc/Renviron

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib

# pin the version of RStudio
ARG RSTUDIO_VERSION_OVERRIDE="2023.12.1-402"
ENV RSTUDIO_VERSION=${RSTUDIO_VERSION_OVERRIDE}
# if rstudio and rstudio-server users are not deleted below, the installation
# script fails when it installs rstudio and tries to add them back in
RUN userdel rstudio-server && \
    userdel rstudio && \
    /rocker_scripts/install_rstudio.sh $RSTUDIO_VERSION

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini && ln -s /tini /usr/bin/

# install dependencies
RUN apt-get update --fix-missing && \
    apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    gpg-agent && \
    apt-get remove -y libnode-dev libnode72:"$(dpkg --print-architecture)" || echo "Conflicting libraries do not exist, continuing..." && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
    gnupg \
    jq \
    nodejs \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libzmq3-dev \
    rclone \
    vim && \
    apt-get purge && \
    apt-get clean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L -s https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -o /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz && \
    tar -zxvf /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -C /tmp && \
    /tmp/git-lfs-3.3.0/install.sh && \
    rm -rf /tmp/git-lfs*

# inject the renku-jupyter stack
COPY --from=renku_base /opt/conda /opt/conda
COPY --from=renku_base --chown=rstudio:rstudio /usr/local/bin/ /usr/local/bin/
COPY --from=renku_base --chown=rstudio:rstudio /home/jovyan/ /home/rstudio/
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
COPY --from=renku_base /renku/bashrc /renku/bashrc

# set permissions of the R library directory to be editable by NB_USER
COPY fix-permissions.sh /usr/local/bin
RUN fix-permissions.sh /usr/local/lib/R && \
    chown 1000:100 /opt/conda && \
    usermod -a -G users rstudio && \
    # this hack lets some of the setup from the base renku image work here
    ln -s /home/${NB_USER} /home/jovyan && \
    # this allows rstudio to run in an iframe in the UI
    echo "" >> /etc/rstudio/rserver.conf && \
    echo "www-frame-origin=same" >> /etc/rstudio/rserver.conf && \
    echo "" >> /etc/rstudio/rserver.conf

USER ${NB_USER}

# set up conda in the NB_USER environment
RUN echo ". ${CONDA_PATH}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    cat /renku/bashrc >> $HOME/.bashrc && \
    echo "source ~/.bashrc" >> ~/.bash_profile

RUN pip install --no-cache-dir "jupyter-rsession-proxy==2.2.0"

# install IRKernel
RUN R --quiet -e "install.packages('IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${CONDA_PATH}')"

COPY post-init.sh /post-init.sh
ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]
CMD [ "jupyter", "server", "--ip", "0.0.0.0" ]

WORKDIR ${HOME}
