ARG BASE_IMAGE=renku/singleuser:latest

FROM $BASE_IMAGE

MAINTAINER Swiss Data Science Center <info@datascience.ch>

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    libapparmor1 \
    libedit2 \
    lsb-release \
    psmisc \
    libssl1.0.0 \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# You can use rsession from rstudio's desktop package as well.
ENV RSTUDIO_PKG=rstudio-server-1.1.463-amd64.deb

RUN wget -q http://download2.rstudio.org/${RSTUDIO_PKG}
RUN dpkg -i ${RSTUDIO_PKG}
RUN rm ${RSTUDIO_PKG}

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

# R packages
RUN conda install --quiet --yes \
    'r-base' \
    'r-irkernel' \
    'r-plyr' \
    'r-devtools' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

# install R Jupyter extension
RUN pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy

# The desktop package uses /usr/lib/rstudio/bin
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"
ENV LD_LIBRARY_PATH="/usr/lib/R/lib:/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server:/opt/conda/lib/R/lib"
