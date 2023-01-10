#! /usr/bin/env bash

# this file does the same as the CI container build - it can be used for
# testing prior to changing the CI builds

LABEL=$(git rev-parse HEAD | cut -c 1-7)
IMAGE_NAME="renku/cuda"
DOCKER_NAME="renku/cuda"
CUDA_VERSION="11.5"
PYTHON_VERSION="3.9.12"
EXTRA_LIBRARIES=""
CUDA_CUDART_PACKAGE="cuda-cudart-11-5=11.5.117-1"
CUDA_COMPAT_PACKAGE="cuda-compat-11-5"
LIBCUDNN_PACKAGE="libcudnn8=8.3.2.44-1+cuda11.5"

docker build . \
  --build-arg BASE_IMAGE="renku/renkulab-py:python-$PYTHON_VERSION-$LABEL" \
  --build-arg CUDA_VERSION="$CUDA_VERSION" \
  --build-arg EXTRA_LIBRARIES="$EXTRA_LIBRARIES" \
  --build-arg CUDA_CUDART_PACKAGE="$CUDA_CUDART_PACKAGE" \
  --build-arg CUDA_COMPAT_PACKAGE="$CUDA_COMPAT_PACKAGE" \
  --build-arg LIBCUDNN_PACKAGE="$LIBCUDNN_PACKAGE" \
  --tag $DOCKER_NAME-cuda:$CUDA_VERSION-$LABEL

echo "IMAGE_NAME=$DOCKER_NAME-cuda:$CUDA_VERSION-$LABEL"
