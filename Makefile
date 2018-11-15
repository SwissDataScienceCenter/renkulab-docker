# -*- coding: utf-8 -*-
#
# Copyright 2017, 2018 - Swiss Data Science Center (SDSC)
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
	r \
	cuda-9.2

DOCKER_PREFIX=renku/singleuser
DOCKER_LABEL=latest
RENKU_VERSION?=master
JUPYTERHUB_VERSION?=0.9.2
GIT_MASTER_HEAD_SHA:=$(shell git rev-parse --short=7 --verify HEAD)

.PHONY: base all

all: base $(extensions)

base:
	cd docker/base && \
	docker build \
		--build-arg RENKU_VERSION=$(RENKU_VERSION) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		-t $(DOCKER_PREFIX):$(DOCKER_LABEL) . && \
	docker tag $(DOCKER_PREFIX):$(DOCKER_LABEL) $(DOCKER_PREFIX):$(GIT_MASTER_HEAD_SHA)


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
%:
	cd docker/$@ && \
	docker build \
		--build-arg BASE_IMAGE=$(DOCKER_PREFIX):$(DOCKER_LABEL) \
		-t $(DOCKER_PREFIX)-$@:$(DOCKER_LABEL) . && \
	docker tag $(DOCKER_PREFIX)-$@:$(DOCKER_LABEL) $(DOCKER_PREFIX)-$@:$(GIT_MASTER_HEAD_SHA)
