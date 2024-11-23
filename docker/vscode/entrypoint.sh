set -ex
WORKDIR=${__WORKDIR__}
mkdir -p "${WORKDIR}/.vscode/extensions"
/codium-server/bin/codium-server \
	--server-base-path "$RENKU_BASE_URL_PATH/" \
	--without-connection-token \
	--host 0.0.0.0 \
	--port 8888 \
	--extensions-dir "${WORKDIR}/.vscode/extensions" \
	--accept-server-license-terms \
	--telemetry-level off \
	--server-data-dir "${WORKDIR}/.vscode"
