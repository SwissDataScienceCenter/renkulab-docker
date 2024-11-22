ARG BASE_IMAGE=renku/renkulab-vscode:latest
FROM $BASE_IMAGE
ARG MINIFORGE_VERSION=24.9.2-0
ARG OS=Linux
ARG ARCH=x86_64
ARG SESSION_USER=vscode
ARG WORKDIR=/home/${SESSION_USER}/work
ARG VENVS_PATH=${WORKDIR}/.venvs
ENV VENVS_PATH=${VENVS_PATH}
USER root
RUN apt-get update && \
	apt-get install -y curl && \
	curl -L "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${OS}-${ARCH}.sh" -o install.sh && \
	rm -rf /var/lib/apt/lists/*

USER ${SESSION_USER}
WORKDIR ${WORKDIR}
ENTRYPOINT ["tini", "--", "sh", "-c"]
CMD ["bash /install.sh -b -u -p ${VENVS_PATH} && ${VENVS_PATH}/bin/conda init && /codium-server/bin/codium-server --server-base-path $RENKU_BASE_URL_PATH/ --without-connection-token --host 0.0.0.0 --port 8888"]
