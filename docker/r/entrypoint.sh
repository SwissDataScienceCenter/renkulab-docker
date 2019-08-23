#!/bin/bash

# Copy the relevant system environment variables to the R-specific locations
VariableArray=("GIT_COMMITTER_NAME"  "GIT_AUTHOR_NAME"  "EMAIL")
for var in ${VariableArray[*]}; do
    if [ -n "${!var}" ]; then
        echo $var=${!var} >> ${HOME}/.Renviron
    fi
done

# add a symlink to the work directory containing the project to the home
# where Rstudio puts you when rstudio starts up.
[ -n "$CI_PROJECT" ] && ln -s /work/${CI_PROJECT} /home/rstudio

# run the command
$@
