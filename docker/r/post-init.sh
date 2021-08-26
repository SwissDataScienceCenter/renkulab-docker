#!/bin/bash

# Copy the relevant system environment variables to the R-specific locations
# Note: In the case of Amalthea-based sessions none of these env variables are
#       defined and nothing will happen. This is ok as we can deal without global
#       git config.
VariableArray=("GIT_COMMITTER_NAME"  "GIT_AUTHOR_NAME"  "EMAIL")
for var in ${VariableArray[*]}; do
    if [ -n "${!var}" ]; then
        echo $var=${!var} >> ${HOME}/.Renviron
    fi
done

if [[ -v NOTEBOOK_DIR && -v PROJECT_NAME ]];
then
    RPROJ_FILE_PATH=${NOTEBOOK_DIR}/${PROJECT_NAME}.Rproj
fi

if [[ -v CI_PROJECT ]];
then
    # add a symlink to the project directory in /home/rstudio
    [ -n "$CI_PROJECT" ] && ln -s /work/${CI_PROJECT} /home/rstudio
    RPROJ_FILE_PATH=${HOME}/${CI_PROJECT}/${CI_PROJECT}.Rproj
fi

# configure rstudio to open the rpath project
if [[ -v RPROJ_FILE_PATH && ( ! -f $RPROJ_FILE_PATH ) ]];
then
cat > $RPROJ_FILE_PATH <<- EOF
Version: 1.0

RestoreWorkspace: Default
SaveWorkspace: Default
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: Sweave
LaTeX: pdfLaTeX
EOF
fi

mkdir -p ${HOME}/.rstudio/projects_settings
if [[ -v RPROJ_FILE_PATH ]];
then
    echo $RPROJ_FILE_PATH >> ${HOME}/.rstudio/projects_settings/next-session-project
fi
