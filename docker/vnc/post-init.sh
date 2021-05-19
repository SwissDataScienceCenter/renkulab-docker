#!/bin/bash

# Make the default terminal folder the project folder in the vnc
echo "cd /work/${CI_PROJECT}" >> ~/.bashrc
# Turn the bell off
echo "bind 'set bell-style none'" >> ~/.bashrc
