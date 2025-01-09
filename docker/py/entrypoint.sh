#!/bin/bash

if [[ -v GIT_AUTHOR_NAME && -v EMAIL && -v CI_PROJECT ]]; then
    # Setup git user
    if [ -z "$(git config --global --get user.name)" ]; then
        git config --global user.name "$GIT_AUTHOR_NAME"
    fi
    if [ -z "$(git config --global --get user.email)" ]; then
        git config --global user.email "$EMAIL"
    fi

    # configure global git credentials
    if [[ -v CI_PROJECT ]]; then
        # set the global git credentials
        git config --global credential.helper "store --file=/work/${CI_PROJECT}/.git/credentials"

        # link to the home work directory
        ln -sf /work/${CI_PROJECT} ~/work
    fi
fi

# install git hooks
renku githooks install >/dev/null 2>&1 || true

# run the post-init script in the root directory (i.e. coming from the image)
if [ -f "/post-init.sh" ]; then
    . /post-init.sh
fi

# run the post-init script in the project directory
if [ -f "./post-init.sh" ]; then
    . ./post-init.sh
fi

# inject ssh public keys if any exist
if [ -f "./.ssh/authorized_keys" ]; then
    echo >>~/.ssh/authorized_keys
    cat ./.ssh/authorized_keys >>~/.ssh/authorized_keys
    echo >>~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# Start the SHH daemon in the background
/usr/sbin/sshd -f /opt/ssh/sshd_config -E /tmp/sshd.log

# Override the jupyter command to be forward compatible with newer
# images that no longer launch the whole server with `jupyter notebook`.
jupyter() {
    if [ "$1" = "notebook" ]; then
        shift
        $(which jupyter) server "$@"
    else
        $(which jupyter) "$@"
    fi
}

if [[ -v RENKU_BASE_URL_PATH ]]; then
    "$@" --ServerApp.port=8888 --ServerApp.base_url="$RENKU_BASE_URL_PATH" \
        --ServerApp.token="" --ServerApp.password="" --ServerApp.allow_remote_access=true \
        --ContentsManager.allow_hidden=true --ServerApp.allow_origin=* \
        --ServerApp.root_dir="${HOME}/work"
fi

# run the command
"$@"
