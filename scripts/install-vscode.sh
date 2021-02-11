#!/bin/sh

VSCODE_VERSION=${VSCODE_VERSION:="3.8.1"}

# code-server installation
wget https://github.com/cdr/code-server/releases/download/v${VSCODE_VERSION}/code-server_${VSCODE_VERSION}_amd64.deb
dpkg -i ./code-server*.deb
rm code-server_${VSCODE_VERSION}_amd64.deb
apt-get clean

# Fix broken python plugin # https://github.com/cdr/code-server/issues/2341
mkdir -p /home/{$NB_USER}/.local/share/code-server/
mkdir -p /home/{$NB_USER}/.local/share/code-server/User
echo "{\"extensions.autoCheckUpdates\": false, \"extensions.autoUpdate\": false}" > /home/{$NB_USER}/.local/share/code-server/User/settings.json
wget https://github.com/microsoft/vscode-python/releases/download/2020.10.332292344/ms-python-release.vsix
code-server --install-extension ./ms-python-release.vsix || true
rm -rf ./ms-python-release.vsix
chown -R 1000:1000 /home/${NB_USER}/.local/share

# Jupyter support
pip install git+https://github.com/betatim/vscode-binder
jupyter serverextension enable --py jupyter_server_proxy
jupyter labextension install @jupyterlab/server-proxy
