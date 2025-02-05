ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE
ARG VSCODIUM_VERSION=1.95.2.24313
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]
RUN apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates curl tini build-essential git git-lfs && \
	mkdir -p /codium-server && \
	curl -L https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VERSION}/vscodium-reh-web-linux-x64-${VSCODIUM_VERSION}.tar.gz | tar -xz -C /codium-server && \
	rm -rf /var/lib/apt/lists/*
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
USER ubuntu
WORKDIR /home/ubuntu

COPY --chown=root:root --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
