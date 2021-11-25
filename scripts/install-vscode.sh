#!/bin/sh

VSCODE_VERSION=${VSCODE_VERSION:="3.12.0"}

# code-server installation
mkdir -p ~/.local/lib
mkdir -p ~/.local/bin
curl -fL https://github.com/cdr/code-server/releases/download/v${VSCODE_VERSION}/code-server-${VSCODE_VERSION}-linux-amd64.tar.gz \
  | tar -C ~/.local/lib -xz
mv ~/.local/lib/code-server-${VSCODE_VERSION}-linux-amd64 ~/.local/lib/code-server-${VSCODE_VERSION}
ln -s ~/.local/lib/code-server-${VSCODE_VERSION}/bin/code-server ~/.local/bin/code-server

# python extension
code-server --install-extension ms-python.python
pip install pylint

# Jupyter support
pip install git+https://github.com/betatim/vscode-binder
jupyter serverextension enable --py jupyter_server_proxy
jupyter labextension install @jupyterlab/server-proxy
