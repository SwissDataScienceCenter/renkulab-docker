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
	cuda-tf \
	vnc \
	julia \
	vnc-qgis \
	vnc-matlab \
	generic \
	batch

DOCKER_PREFIX?=renku/renkulab
DOCKER_LABEL?=latest
GIT_MASTER_HEAD_SHA:=$(shell git rev-parse --short=7 --verify HEAD)

RVERSION?=4.0.4
BIOC_VERSION?=devel
R_TAG=-r$(RVERSION)
BIOC_TAG=$(BIOC_VERSION)
TENSORFLOW_VERSION?=2.2.0
BASE_IMAGE_TAG?=lab-3.4.0

.PHONY: all

all: $(extensions)

login:
	@echo "${DOCKER_PASSWORD}" | docker login -u="${DOCKER_USERNAME}" --password-stdin ${DOCKER_REGISTRY}

push:
	for ext in "" $(extensions) ; do \
		if test "$$ext" != "" ; then \
			ext=-$$ext; \
		fi; \
		docker push $(DOCKER_PREFIX)$$ext:$(DOCKER_LABEL) ; \
		docker push $(DOCKER_PREFIX)$$ext:$(GIT_MASTER_HEAD_SHA) ; \
	done

pull:
	for ext in "" $(extensions) ; do \
		if test "$$ext" != "" ; then \
			ext=-$$ext; \
		fi; \
		docker pull $(DOCKER_PREFIX)$$ext:$(DOCKER_LABEL) ; \
	done

# all of the containers use this as a base
py:
	docker build docker/py \
		--build-arg BASE_IMAGE=jupyter/base-notebook:$(BASE_IMAGE_TAG) \
		-t $(DOCKER_PREFIX)-$@:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-$@:$(DOCKER_LABEL) $(DOCKER_PREFIX)-$@:$(GIT_MASTER_HEAD_SHA)
	docker tag $(DOCKER_PREFIX)-$@:$(DOCKER_LABEL) $(DOCKER_PREFIX)-$@:$(BASE_IMAGE_TAG)-$(GIT_MASTER_HEAD_SHA)

r: py
	docker build docker/r \
		--build-arg RENKU_BASE=renku/renkulab-py:$(GIT_MASTER_HEAD_SHA) \
		--build-arg RVERSION=$(RVERSION) \
		-t $(DOCKER_PREFIX)-r:$(DOCKER_LABEL)$(R_TAG) && \
	docker tag $(DOCKER_PREFIX)-r:$(DOCKER_LABEL)$(R_TAG) $(DOCKER_PREFIX)-r:$(GIT_MASTER_HEAD_SHA)$(R_TAG)

cuda: py
	docker build docker/cuda \
		--build-arg RENKU_BASE=renku/renkulab-py:$(GIT_MASTER_HEAD_SHA) \
		--build-arg TENSORFLOW_VERSION=$(TENSORFLOW_VERSION) \
		-t $(DOCKER_PREFIX)-cuda:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-cuda:$(DOCKER_LABEL) $(DOCKER_PREFIX)-cuda:$(GIT_MASTER_HEAD_SHA)
	
# The cuda-tf dockerfile does not seem to be maintained
# cuda-tf: py
# 	docker build docker/cuda-tf \
# 		--build-arg RENKU_BASE=renku/renkulab-py:$(GIT_MASTER_HEAD_SHA) \
# 		--build-arg TENSORFLOW_VERSION=$(TENSORFLOW_VERSION) \
# 		-t $(DOCKER_PREFIX)-cuda-tf:$(DOCKER_LABEL) && \
# 	docker tag $(DOCKER_PREFIX)-cuda-tf:$(DOCKER_LABEL) $(DOCKER_PREFIX)-cuda-tf:$(GIT_MASTER_HEAD_SHA)

vnc: py
	docker build docker/vnc \
		--build-arg BASE_IMAGE=renku/renkulab-py:$(GIT_MASTER_HEAD_SHA) \
		-t $(DOCKER_PREFIX)-vnc:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-vnc:$(DOCKER_LABEL) $(DOCKER_PREFIX)-vnc:$(GIT_MASTER_HEAD_SHA)

julia: py
	docker build docker/julia \
		--build-arg BASE_IMAGE=renku/renkulab-py:$(GIT_MASTER_HEAD_SHA) \
		-t $(DOCKER_PREFIX)-julia:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-julia:$(DOCKER_LABEL) $(DOCKER_PREFIX)-julia:$(GIT_MASTER_HEAD_SHA)

generic: py
	docker build docker/generic \
		--build-arg BASE_IMAGE=renku/renkulab-py:$(GIT_MASTER_HEAD_SHA) \
		-t $(DOCKER_PREFIX)-generic:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-generic:$(DOCKER_LABEL) $(DOCKER_PREFIX)-generic:$(GIT_MASTER_HEAD_SHA)

vnc-matlab: py
	docker build docker/matlab \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_MASTER_HEAD_SHA) \
		-t $(DOCKER_PREFIX)-matlab:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-matlab:$(DOCKER_LABEL) $(DOCKER_PREFIX)-matlab:$(GIT_MASTER_HEAD_SHA)

vnc-qgis: py
	docker build docker/qgis \
		--build-arg BASE_IMAGE=renku/renkulab-vnc:$(GIT_MASTER_HEAD_SHA) \
		-t $(DOCKER_PREFIX)-qgis:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-qgis:$(DOCKER_LABEL) $(DOCKER_PREFIX)-qgis:$(GIT_MASTER_HEAD_SHA)

batch: py
	docker build docker/batch \
		-t $(DOCKER_PREFIX)-batch:$(DOCKER_LABEL) && \
	docker tag $(DOCKER_PREFIX)-batch:$(DOCKER_LABEL) $(DOCKER_PREFIX)-batch:$(GIT_MASTER_HEAD_SHA)

