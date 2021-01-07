#!/bin/bash

# Slip in a replacement for the julia command that sets uses the project
# environment rather than the root environment
if [[ -v CI_PROJECT ]];
then
    ln -sf /work/${CI_PROJECT} ~/work
    echo '#!/usr/bin/env bash' > ~/.local/bin/julia
    printf '/usr/local/bin/julia --project=/work/%s/ "$@"\n' ${CI_PROJECT} >> ~/.local/bin/julia
    chmod u+x ~/.local/bin/julia
fi
