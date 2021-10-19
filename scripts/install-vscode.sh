#!/bin/sh

VSCODE_VERSION=${VSCODE_VERSION:="3.10.2"}

# code-server installation
mkdir -p ~/.local/lib
curl -fL https://github.com/cdr/code-server/releases/download/v${VSCODE_VERSION}/code-server-${VSCODE_VERSION}-linux-amd64.tar.gz \
  | tar -C ~/.local/lib -xz 
mv ~/.local/lib/code-server-${VSCODE_VERSION}-linux-amd64 ~/.local/lib/code-server-${VSCODE_VERSION}
mkdir -p ~/.local/bin
echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc
ln -s ~/.local/lib/code-server-${VSCODE_VERSION}/bin/code-server ~/.local/bin/code-server

# python extension
code-server --install-extension ms-python.python
pip install pylint

# Jupyter support
pip install git+https://github.com/betatim/vscode-binder
jupyter serverextension enable --py jupyter_server_proxy
jupyter labextension install @jupyterlab/server-proxy
