# define build arguments
ARG RENKU_BASE=renku/renkulab-py:latest
ARG BASE_IMAGE=mathworks/matlab:r2024a

# define base images
FROM $RENKU_BASE as renku_base
FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root

ENV NB_USER matlab
ENV NB_UID 1000
ENV NB_GID 100
ENV VENV_DIR /srv/venv
ENV HOME /home/${NB_USER}
ENV SHELL bash
ENV CONDA_PATH /opt/conda
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# prepend conda and local/bin to PATH
ENV PATH ${HOME}/.local/bin:${CONDA_PATH}/bin:${HOME}/.renku/bin:$PATH

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
    git \
    gpg-agent \
    rclone \
    vim && \
    apt-get purge && \
    apt-get clean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L -s https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -o /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz && \
    tar -zxvf /tmp/git-lfs-linux-"$(dpkg --print-architecture)"-v3.3.0.tar.gz -C /tmp && \
    /tmp/git-lfs-3.3.0/install.sh && \
    rm -rf /tmp/git-lfs* && \
    curl -L -o /usr/bin/mpm -s https://www.mathworks.com/mpm/glnxa64/mpm && \
    chmod a+x /usr/bin/mpm

# inject the renku-jupyter stack
COPY --from=renku_base /opt/conda /opt/conda
COPY --from=renku_base --chown=matlab:matlab /usr/local/bin/ /usr/local/bin/
COPY --from=renku_base --chown=matlab:matlab /home/jovyan/ /home/matlab/
COPY --from=renku_base /entrypoint.sh /entrypoint.sh
COPY --from=renku_base /renku/bashrc /renku/bashrc

# set permissions of the R library directory to be editable by NB_USER
RUN chown 1000:100 /opt/conda && \
    mkdir /usr/share/matlab && \
    chown 1000:1000 /usr/share/matlab && \
    # this hack lets some of the setup from the base renku image work here
    ln -s /home/${NB_USER} /home/jovyan

USER ${NB_USER}

# set up conda in the NB_USER environment
RUN echo ". ${CONDA_PATH}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    cat /renku/bashrc >> $HOME/.bashrc && \
    echo "source ~/.bashrc" >> ~/.bash_profile

RUN pip install --no-cache-dir "jupyter-matlab-proxy"

ENTRYPOINT [ "/tini", "--", "/entrypoint.sh" ]
CMD [ "jupyter", "server", "--ip", "0.0.0.0" ]

WORKDIR ${HOME}
