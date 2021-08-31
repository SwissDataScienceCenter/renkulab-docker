#!/bin/bash

if [[ -v GIT_AUTHOR_NAME && -v EMAIL && -v CI_PROJECT ]];
then
    # Setup git user
    if [ -z "$(git config --global --get user.name)" ]; then
        git config --global user.name "$GIT_AUTHOR_NAME"
    fi
    if [ -z "$(git config --global --get user.email)" ]; then
        git config --global user.email "$EMAIL"
    fi

    # configure global git credentials
    if [[ -v CI_PROJECT ]];
    then
        # set the global git credentials
        git config --global credential.helper "store --file=/work/${CI_PROJECT}/.git/credentials"

        # link to the home work directory
        ln -sf /work/${CI_PROJECT} ~/work
    fi
fi

# install git hooks
# we need to avoid a race condition where renku could try to install
# the git hooks before the repo is actually cloned during the execution
# of the entrypoint of the git sidecar
if [[ -v GIT_CLONE_REPO && -v NOTEBOOK_DIR ]]
then
    while [[ ! -f ./.renku-repo-clone-complete ]]
    do
        echo "Waiting for repository to be cloned..."
        sleep 1
    done
    rm ./.renku-repo-clone-complete
fi
~/.local/bin/renku githooks install || true

# run the post-init script in the root directory (i.e. coming from the image)
if [ -f "/post-init.sh" ]; then
    . /post-init.sh
fi

# run the post-init script in the project directory
if [ -f "./post-init.sh" ]; then
    . ./post-init.sh
fi

# run the command
$@
