#!/bin/bash

set -ex

HOME="${HOME:-/home/ubuntu}"
RENKU_MOUNT_DIR="${RENKU_MOUNT_DIR:-${HOME}/work}"

mkdir -p "${RENKU_MOUNT_DIR}/.vscode/extensions"

# Install python extensions
DEFAULT_VSCODIUM_EXTENSIONS="\
  ms-python.python \
  ms-toolsai.jupyter \
"
VSCODIUM_EXTENSIONS="${VSCODIUM_EXTENSIONS:-${DEFAULT_VSCODIUM_EXTENSIONS}}"
VSCODIUM_EXTENSIONS=($VSCODIUM_EXTENSIONS)
for ext in "${VSCODIUM_EXTENSIONS[@]}"; do
  /codium-server/bin/codium-server \
      --extensions-dir "${RENKU_MOUNT_DIR}/.vscode/extensions" \
    --server-data-dir "${RENKU_MOUNT_DIR}/.vscode" \
    --install-extension "${ext}" || true
done

RENKU_WORKING_DIR="${RENKU_WORKING_DIR:-${RENKU_MOUNT_DIR}}"

RENKU_BASE_URL_PATH="${RENKU_BASE_URL_PATH:-/}"
if [[ "${RENKU_BASE_URL_PATH}" != */ ]]; then
  RENKU_BASE_URL_PATH="${RENKU_BASE_URL_PATH}/"
fi

RENKU_SESSION_IP="${RENKU_SESSION_IP:-0.0.0.0}"
RENKU_SESSION_PORT="${RENKU_SESSION_PORT:-8888}"

if hash "python" 2> /dev/null; then
  set +e
  python -m venv "${RENKU_MOUNT_DIR}/.venv" --system-site-packages
  source "${RENKU_MOUNT_DIR}/.venv/bin/activate"
  set -e
fi

/codium-server/bin/codium-server \
  --server-base-path "${RENKU_BASE_URL_PATH}" \
  --host "${RENKU_SESSION_IP}" \
  --port "${RENKU_SESSION_PORT}" \
  --extensions-dir "${RENKU_MOUNT_DIR}/.vscode/extensions" \
  --server-data-dir "${RENKU_MOUNT_DIR}/.vscode" \
  --without-connection-token \
  --accept-server-license-terms \
  --telemetry-level off \
  --default-folder "${RENKU_WORKING_DIR}"
