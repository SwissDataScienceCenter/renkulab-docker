ARG BASE_IMAGE=renku/renkulab-cuda:latest
FROM $BASE_IMAGE

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

#
# Install TensorFlow (from https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile)
#

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

# Options:
#   tensorflow
#   tensorflow-gpu
#   tf-nightly
#   tf-nightly-gpu
# Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# Installs the latest version by default.
USER $NB_USER
ARG TF_PACKAGE=tensorflow-gpu
ARG TF_PACKAGE_VERSION=2.5.0
RUN python3 -m pip install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}
