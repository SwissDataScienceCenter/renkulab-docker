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

DOCKER_PREFIX?=renku/renkulab
DOCKER_LABEL?=latest
GIT_COMMIT_SHA?=$(shell git rev-parse --short=7 --verify HEAD)

# for building the base image
BASE_IMAGE_TAG?=lab-3.4.0
RENKU_PYTHON_BASE_IMAGE_TAG?=3.9

# for building the r container
RVERSION?=4.2.0
TENSORFLOW_VERSION?=2.2.0

# for building the julia container
JULIAVERSION?=1.7.1

# for building the bioconductor container
BIOC_VERSION?=devel
BIOC_TAG=$(BIOC_VERSION)

# cuda defaults - these should be updated from time to time
CUDA_VERSION?=11.7
PYTHON_VERSION?=3.9.12
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
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-$@:$(RENKU_PYTHON_BASE_IMAGE_TAG)-$(GIT_COMMIT_SHA) 

r: py
	docker build docker/r \
		--build-arg RENKU_BASE=renku/renkulab-py:$(RENKU_PYTHON_BASE_IMAGE_TAG)-$(GIT_COMMIT_SHA) \
		--build-arg RVERSION=$(RVERSION) \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-r:$(RVERSION)-$(GIT_COMMIT_SHA)

# BASE_IMAGE was used for all the docker files, but if there are dependencies,
# it can be expected to mean different things in different contexts; hence
# CUDA_BASE_IMAGE was introduced here
cuda: py
	docker build docker/cuda \
		--build-arg CUDA_BASE_IMAGE=renku/renkulab-py:$(RENKU_PYTHON_BASE_IMAGE_TAG)-$(GIT_COMMIT_SHA) \
		--build-arg CUDA_VERSION=$(CUDA_VERSION) \
		--build-arg EXTRA_LIBRARIES="$(EXTRA_LIBRARIES)" \
		--build-arg CUDA_CUDART_PACKAGE="$(CUDA_CUDART_PACKAGE)" \
		--build-arg CUDA_COMPAT_PACKAGE="$(CUDA_COMPAT_PACKAGE)" \
		--build-arg LIBCUDNN_PACKAGE="$(LIBCUDNN_PACKAGE)" \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-cuda:$(CUDA_VERSION)-$(GIT_COMMIT_SHA)

# this image is just tagged with the commit hash
vnc: py
	docker build docker/vnc \
		--build-arg BASE_IMAGE=renku/renkulab-py:$(RENKU_PYTHON_BASE_IMAGE_TAG)-$(GIT_COMMIT_SHA) \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-vnc:$(GIT_COMMIT_SHA)

# this image is tagged with the julia version and the commit hash
julia: py
	docker build docker/julia \
		--build-arg BASE_IMAGE=renku/renkulab-py:$(RENKU_PYTHON_BASE_IMAGE_TAG)-$(GIT_COMMIT_SHA) \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-julia:$(JULIAVERSION)-$(GIT_COMMIT_SHA)

# this image is built on the vnc image and tagged as matlab with the commit hash
vnc-matlab: vnc
	docker build docker/matlab \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_COMMIT_SHA) \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-matlab:$(GIT_COMMIT_SHA) 

vnc-qgis: vnc
	docker build docker/qgis \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_COMMIT_SHA) \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-qgis:$(GIT_COMMIT_SHA) 

batch: py
	docker build docker/batch \
		--build-arg RENKU_BASE="$(DOCKER_PREFIX)-py:3.9-$(GIT_COMMIT_SHA)" \
		--build-arg BASE_IMAGE="python:3.9-slim-buster" \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-batch:$(GIT_COMMIT_SHA) 

bioc: py
	docker build docker/r \
		--build-arg RENKU_BASE="$(DOCKER_PREFIX)-py:3.9-$(GIT_COMMIT_SHA)" \
		--build-arg BASE_IMAGE="bioconductor/bioconductor_docker:$(BIOC_VERSION)" \
		--platform=linux/amd64 \
		-t $(DOCKER_PREFIX)-bioc:$(BIOC_VERSION)-$(GIT_COMMIT_SHA)

