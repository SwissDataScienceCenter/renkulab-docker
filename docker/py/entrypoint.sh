#!/bin/bash

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

#
# copy the environment from renku-env repo
#

# clone the repo
proto=$(echo $GITLAB_URL | sed -e's,^\(.*://\).*,\1,g')
url=$(echo ${GITLAB_URL/$proto/})
user=$(echo ${CI_REPOSITORY_URL/$proto/} | grep @ | cut -d@ -f1)

git clone --depth 1 ${GITLAB_URL}/${JUPYTERHUB_USER}/renku-env.git /tmp/renku-env || true

# append the contents of all the files to same files in ${HOME}
find /tmp/renku-env -not -path '*.git*' -type f -print0 | xargs --null -I{} sh -c 'cat {} >> ${HOME}/$(basename "{}")' || true

# install git hooks
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
