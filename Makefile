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

PLATFORM?=linux/amd64

DOCKER_PREFIX?=renku/renkulab
GIT_COMMIT_SHA?=$(shell git rev-parse --short=7 --verify HEAD)

# for building the base image
BASE_IMAGE_TAG?=lab-3.6.1
RENKU_BASE?=$(DOCKER_PREFIX)-py:latest
DOCKER_LABEL?=latest

# RStudio version
RSTUDIO_VERSION_OVERRIDE?=2022.02.3-492
RSTUDIO_BASE_IMAGE?=rocker/verse:devel

# for building the r container
RVERSION?=4.2.0
TENSORFLOW_VERSION?=2.2.0

# for building the julia container
JULIAVERSION?=1.7.1

# for building the bioconductor container
BIOC_VERSION?=devel
BIOC_TAG=$(BIOC_VERSION)

# cuda defaults - these should be updated from time to time
CUDA_BASE_IMAGE?=renku/renkulab-py:$(DOCKER_LABEL)
CUDA_VERSION?=11.7
EXTRA_LIBRARIES?=
CUDA_CUDART_PACKAGE?=cuda-cudart-11-7=11.7.60-1
CUDA_COMPAT_PACKAGE?=cuda-compat-11-7
LIBCUDNN_PACKAGE?=libcudnn8=8.5.0.96-1+cuda11.7

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
	docker build docker/py \
		--build-arg BASE_IMAGE=jupyter/base-notebook:$(BASE_IMAGE_TAG) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-$@:$(DOCKER_LABEL)

r: py
	docker build docker/r \
		--build-arg BASE_IMAGE=$(RSTUDIO_BASE_IMAGE) \
		--build-arg RENKU_BASE=$(RENKU_BASE) \
		--build-arg RVERSION=$(RVERSION) \
		--build-arg RSTUDIO_VERSION_OVERRIDE=$(RSTUDIO_VERSION_OVERRIDE) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-r:$(DOCKER_LABEL)

# BASE_IMAGE was used for all the docker files, but if there are dependencies,
# it can be expected to mean different things in different contexts; hence
# CUDA_BASE_IMAGE was introduced here
cuda: py
	docker build docker/cuda \
		--build-arg CUDA_BASE_IMAGE="$(CUDA_BASE_IMAGE)" \
		--build-arg CUDA_COMPAT_PACKAGE="$(CUDA_COMPAT_PACKAGE)" \
		--build-arg CUDA_CUDART_PACKAGE="$(CUDA_CUDART_PACKAGE)" \
		--build-arg CUDA_VERSION="$(CUDA_VERSION)" \
		--build-arg EXTRA_LIBRARIES="$(EXTRA_LIBRARIES)" \
		--build-arg LIBCUDNN_PACKAGE="$(LIBCUDNN_PACKAGE)" \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-cuda:$(DOCKER_LABEL)

# this image is just tagged with the commit hash
vnc: py
	docker build docker/vnc \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		-t $(DOCKER_PREFIX)-vnc:$(DOCKER_LABEL)

# this image is tagged with the julia version and the commit hash
julia: py
	docker build docker/julia \
		--build-arg BASE_IMAGE=$(RENKU_BASE) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-julia:$(DOCKER_LABEL)

# this image is built on the vnc image and tagged as matlab with the commit hash
vnc-matlab: vnc
	docker build docker/matlab \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_COMMIT_SHA) \
		-t $(DOCKER_PREFIX)-matlab:$(GIT_COMMIT_SHA)

vnc-qgis: vnc
	docker build docker/qgis \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_COMMIT_SHA) \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-qgis:$(GIT_COMMIT_SHA)

batch: py
	docker build docker/batch \
		--build-arg RENKU_BASE="$(RENKU_BASE)" \
		--build-arg BASE_IMAGE="python:3.9-slim-buster" \
		-t $(DOCKER_PREFIX)-batch:$(GIT_COMMIT_SHA)

bioc: py
	docker build docker/r \
		--build-arg RENKU_BASE="$(RENKU_BASE)" \
		--build-arg BASE_IMAGE="bioconductor/bioconductor_docker:$(BIOC_VERSION)" \
		--platform=$(PLATFORM) \
		-t $(DOCKER_PREFIX)-bioc:$(DOCKER_LABEL)
