# -*- coding: utf-8 -*-
#
# Copyright 2017-2019 - Swiss Data Science Center (SDSC)
# A partnership between École Polytechnique Fédérale de Lausanne (EPFL) and
# Eidgenössische Technische Hochschule Zürich (ETHZ).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

extensions = \
	py \
	r \
	cuda \
	vnc \
	julia \
	vnc-qgis \
	vnc-matlab \
	batch \
	bioc

BUILDKIT_INLINE_CACHE?=1
PLATFORM?=linux/amd64
BUILD_CMD=build
# set the build command
ifdef USE_BUILDX
    BUILD_CMD=buildx build
endif

# use BUILDX_EXTRA_FLAGS to set either --push or --load
BUILDX_EXTRA_FLAGS?=

DOCKER_PREFIX?=renku/renkulab
GIT_COMMIT_SHA?=$(shell git rev-parse --short=7 --verify HEAD)

# for building the base image
DEFAULT_PYTHON_VERSION?=3.10
BASE_IMAGE_TAG?=python-$(DEFAULT_PYTHON_VERSION)
PY_DOCKER_LABEL?=$(DEFAULT_PYTHON_VERSION)-$(GIT_COMMIT_SHA)
RENKU_BASE?=$(DOCKER_PREFIX)-py:$(PY_DOCKER_LABEL)

# RStudio version
RSTUDIO_VERSION_OVERRIDE?=2022.02.3-492
RSTUDIO_BASE_IMAGE?=rocker/verse:devel
RVERSION?=4.2.0
R_DOCKER_LABEL?=$(RVERSION)-$(GIT_COMMIT_SHA)

# for building the julia container
JULIA_VERSION?=1.9.0
JULIA_CHECKSUM?=00c614466ef9809c2eb23480e38d196a2c577fff2730c4f83d135b913d473359
JULIA_DOCKER_LABEL?=$(JULIA_VERSION)-$(GIT_COMMIT_SHA)

# for building the bioconductor container
BIOC_VERSION?=devel
BIOC_DOCKER_LABEL?=$(BIOC_VERSION)-$(GIT_COMMIT_SHA)

# cuda defaults - these should be updated from time to time
CUDA_BASE_IMAGE?=renku/renkulab-py:$(DOCKER_LABEL)
CUDA_VERSION?=11.7
EXTRA_LIBRARIES?=
CUDA_CUDART_PACKAGE?=cuda-cudart-11-7=11.7.60-1
CUDA_COMPAT_PACKAGE?=cuda-compat-11-7
LIBCUDNN_PACKAGE?=libcudnn8=8.5.0.96-1+cuda11.7
CUDA_DOCKER_LABEL?=$(CUDA_VERSION)-$(GIT_COMMIT_SHA)

# setup for the extras
EXTRA_DOCKER_LABEL?=$(GIT_COMMIT_SHA)

.PHONY: all

all: $(extensions)

login:
	@echo "${DOCKER_PASSWORD}" | docker login -u="${DOCKER_USERNAME}" --password-stdin ${DOCKER_REGISTRY}

# push assumes that all images are identified by as ext:DOCKER_LABEL
# and ext:(COMMIT_HASH). DOCKER_LABEL defaults to `latest`.
push:
	for ext in "" $(extensions) ; do \
		if test "$$ext" != "" ; then \
			ext=-$$ext; \
		fi; \
		docker push $(DOCKER_PREFIX)$$ext:$(DOCKER_LABEL) ; \
		docker push $(DOCKER_PREFIX)$$ext:$(GIT_COMMIT_SHA) ; \
	done

# pull will pull down latest images for all extensions.
pull:
	for ext in "" $(extensions) ; do \
		if test "$$ext" != "" ; then \
			ext=-$$ext; \
		fi; \
		docker pull $(DOCKER_PREFIX)$$ext:$(DOCKER_LABEL) ; \
	done

# all of the containers use this as a base. It is assumed that the following
# are defined:
# BASE_IMAGE_TAG: used to identify the jupyter base notebook to build from
# RENKU_PYTHON_BASE_TAG: used to tag the resulting image
py:
	docker $(BUILD_CMD) docker/py \
		--build-arg BASE_IMAGE=jupyter/base-notebook:$(BASE_IMAGE_TAG) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-$@:$(PY_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

r: py
	docker $(BUILD_CMD) docker/r \
		--build-arg BASE_IMAGE=$(RSTUDIO_BASE_IMAGE) \
		--build-arg RENKU_BASE=$(RENKU_BASE) \
		--build-arg RVERSION=$(RVERSION) \
		--build-arg RSTUDIO_VERSION_OVERRIDE=$(RSTUDIO_VERSION_OVERRIDE) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-r:$(R_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

cuda: py
	docker $(BUILD_CMD) docker/cuda \
		--build-arg RENKU_BASE="$(RENKU_BASE)" \
		--build-arg CUDA_COMPAT_PACKAGE="$(CUDA_COMPAT_PACKAGE)" \
		--build-arg CUDA_CUDART_PACKAGE="$(CUDA_CUDART_PACKAGE)" \
		--build-arg CUDA_VERSION="$(CUDA_VERSION)" \
		--build-arg EXTRA_LIBRARIES="$(EXTRA_LIBRARIES)" \
		--build-arg LIBCUDNN_PACKAGE="$(LIBCUDNN_PACKAGE)" \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-cuda:$(CUDA_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

# this image is tagged with the julia version and the commit hash
julia: py
	docker $(BUILD_CMD) docker/julia \
		--build-arg RENKU_BASE=$(RENKU_BASE) \
		--build-arg JULIA_CHECKSUM=$(JULIA_CHECKSUM) \
		--build-arg JULIA_VERSION_ARG=$(JULIA_VERSION) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-julia:$(JULIA_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

# this image is just tagged with the commit hash
vnc: py
	docker $(BUILD_CMD) docker/vnc \
		--build-arg RENKU_BASE=$(RENKU_BASE) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-vnc:$(EXTRA_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

# this image is built on the vnc image and tagged as matlab with the commit hash
vnc-%: vnc
	docker $(BUILD_CMD) docker/$* \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_COMMIT_SHA) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-$*:$(EXTRA_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

batch: py
	docker $(BUILD_CMD) docker/batch \
		--build-arg RENKU_BASE="$(RENKU_BASE)" \
		--build-arg BASE_IMAGE="python:3.10-slim-buster" \
		-t $(DOCKER_PREFIX)-batch:$(EXTRA_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)

bioc: py
	docker $(BUILD_CMD) docker/r \
		--build-arg RENKU_BASE="$(RENKU_BASE)" \
		--build-arg BASE_IMAGE="bioconductor/bioconductor_docker:$(BIOC_VERSION)" \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-bioc:$(BIOC_DOCKER_LABEL) \
		$(BUILDX_EXTRA_FLAGS)
