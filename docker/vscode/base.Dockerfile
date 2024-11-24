ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:bookworm
FROM $BASE_IMAGE
ARG VSCODIUM_VERSION=1.95.2.24313
ARG SESSION_USER=vscode
ARG WORKDIR=/home/${SESSION_USER}/work
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]
RUN apt-get update && \
	apt-get install -y --no-install-recommends curl tini git-lfs && \
	mkdir -p /codium-server && \
	curl -L https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VERSION}/vscodium-reh-web-linux-x64-${VSCODIUM_VERSION}.tar.gz | tar -xz -C /codium-server && \
	rm -rf /var/lib/apt/lists/*

USER ${SESSION_USER}
COPY entrypoint.sh /entrypoint.sh
WORKDIR ${WORKDIR}
# We are setting this to a weird double underscore name to avoid collisions with user-set vars
ENV __WORKDIR__=${WORKDIR}
ENTRYPOINT ["tini", "--", "/bin/bash", "/entrypoint.sh"]
