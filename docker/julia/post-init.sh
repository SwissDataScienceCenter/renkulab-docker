#!/bin/bash

# Slip in a replacement for the julia command that sets uses the project
# environment rather than the root environment

# Pre amalthea
if [[ -v CI_PROJECT ]];
then
    ln -sf /work/${CI_PROJECT} ~/work
    echo '#!/usr/bin/env bash' > ~/.local/bin/julia
    printf '/usr/local/bin/julia --project=/work/%s/ "$@"\n' ${CI_PROJECT} >> ~/.local/bin/julia
    chmod u+x ~/.local/bin/julia
fi

# With amalthea
if [[ -v PROJECT_NAME && -v NOTEBOOK_DIR ]];
then
    echo '#!/usr/bin/env bash' > ~/.local/bin/julia
    printf '/usr/local/bin/julia --project=%s/ "$@"\n' ${NOTEBOOK_DIR} >> ~/.local/bin/julia
    chmod u+x ~/.local/bin/julia
fi

