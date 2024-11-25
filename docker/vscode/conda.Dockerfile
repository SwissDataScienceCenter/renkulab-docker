ARG BASE_IMAGE=renku/renkulab-vscode:latest
FROM $BASE_IMAGE
ARG MICROMAMBA_VERSION=2.0.2-2
ARG MAMBA_VERSION=1.5.9
ARG CONDA_VERSION=24.9.2
ARG PYTHON_VERSION=3.12.7
ARG OS=linux
ARG ARCH=64
ARG SESSION_USER=vscode
ARG WORKDIR=/home/${SESSION_USER}/work
ARG VENVS_PATH=${WORKDIR}/.venvs
ENV __VENVS_PATH__=${VENVS_PATH}
ENV __PYTHON_VERSION__=${PYTHON_VERSION}
ENV __MAMBA_VERSION__=${MAMBA_VERSION}
ENV __CONDA_VERSION__=${CONDA_VERSION}
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]
USER root
RUN apt-get update && \
	apt-get install -y curl --no-install-recommends && \
	curl -L "https://github.com/mamba-org/micromamba-releases/releases/download/${MICROMAMBA_VERSION}/micromamba-${OS}-${ARCH}" -o /usr/local/bin/micromamba && \
	chmod a+x /usr/local/bin/micromamba && \
	rm -rf /var/lib/apt/lists/*

USER ${SESSION_USER}
WORKDIR ${WORKDIR}
ENTRYPOINT ["tini", "--", "sh", "-c"]
CMD ["set -ex && micromamba install --yes --root-prefix=${__VENVS_PATH__} --prefix=${__VENVS_PATH__} python=${__PYTHON_VERSION__} mamba=${__MAMBA_VERSION__} conda=${__CONDA_VERSION__} && ${__VENVS_PATH__}/bin/mamba init && ${__VENVS_PATH__}/bin/conda config --add channels conda-forge && ${__VENVS_PATH__}/bin/conda config --set channel_priority strict && bash /entrypoint.sh"]
