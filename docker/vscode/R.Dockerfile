ARG BASE_IMAGE=renku/renkulab-vscode:latest
FROM $BASE_IMAGE
ARG R_VERSION=4.4.2
ARG SESSION_USER=vscode
ARG WORKDIR=/home/${SESSION_USER}/work

USER root
# From https://docs.posit.co/resources/install-r.html
RUN curl -O https://cdn.rstudio.com/r/debian-12/pkgs/r-${R_VERSION}_1_amd64.deb \
	&& apt-get update \
	&& apt-get install -y ./r-${R_VERSION}_1_amd64.deb \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf ./r-${R_VERSION}_1_amd64.deb \
	&& sudo ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R \
	&& sudo ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

USER ${SESSION_USER}
WORKDIR ${WORKDIR}
# The .Renviron changes allow R to install packages in the work directory
# See https://www.r-bloggers.com/2020/10/customizing-your-package-library-location/
# The .Rprofile changes allow R to be able to use precompiled packages
# See https://packagemanager.posit.co/client/#/repos/cran/setup
RUN mkdir -p ${WORKDIR}/.rlibs \
	&& echo "\nR_LIBS_SITE=\"${WORKDIR}/.rlibs\"\n" >> /home/${SESSION_USER}/.Renviron \
	&& echo "\noptions(repos = c(CRAN = \"https://packagemanager.posit.co/cran/__linux__/bookworm/latest\"))\n" >>  /home/${SESSION_USER}/.Rprofile
