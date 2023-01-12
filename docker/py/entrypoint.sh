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
renku githooks install || true

# run the post-init script in the root directory (i.e. coming from the image)
if [ -f "/post-init.sh" ]; then
    . /post-init.sh
fi

# run the post-init script in the project directory
if [ -f "./post-init.sh" ]; then
    . ./post-init.sh
fi

# Start the SHH daemon in the background
/usr/sbin/sshd -f /opt/ssh/sshd_config -E /tmp/sshd.log &> /dev/null

# run the command
$@
