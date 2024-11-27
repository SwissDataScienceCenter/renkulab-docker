ARG BASE_IMAGE=renku/renkulab-vscode:latest
FROM $BASE_IMAGE
ARG PYENV_VERSION=v2.4.17
ARG PYTHON_VERSION=3.12.7
# Empty string for poetry version means the latest version
ARG POETRY_VERSION=""
ARG SESSION_USER=vscode
ARG WORKDIR=/home/${SESSION_USER}
ARG MOUNTDIR=${WORKDIR}/work
ARG VENVS_PATH=${MOUNTDIR}/.venvs
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]
USER root
RUN apt-get update && \
	apt-get install -y --no-install-recommends curl libz-dev libreadline-dev libncurses-dev libsqlite3-dev libssl-dev liblzma-dev libgdbm-dev libbz2-dev libffi-dev && \
	mkdir -p /python-build && \
	curl -L https://github.com/pyenv/pyenv/archive/refs/tags/${PYENV_VERSION}.tar.gz | tar -xz -C /python-build && \
	/bin/sh /python-build/*/plugins/python-build/install.sh && \
	python-build ${PYTHON_VERSION} /usr/local && \
	rm -rf /python-build && \
	rm -rf /var/lib/apt/lists/*

USER ${SESSION_USER}
ENV __MOUNTDIR__=${MOUNTDIR}
RUN curl -sSL https://install.python-poetry.org | python3 - --version=${POETRY_VERSION} && \
	/home/${SESSION_USER}/.local/bin/poetry config virtualenvs.path ${VENVS_PATH}
WORKDIR ${WORKDIR}
