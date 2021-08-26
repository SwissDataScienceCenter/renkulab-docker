#!/bin/bash

# Make the default terminal folder the project folder in the vnc
if [[ -v CI_PROJECT ]]
then
    echo "cd /work/${CI_PROJECT}" >> ~/.bashrc
fi
if [[ -v NOTEBOOK_DIR ]]
then
    echo "cd ${NOTEBOOK_DIR}" >> ~/.bashrc
fi
# Turn the bell off
echo "bind 'set bell-style none'" >> ~/.bashrc
