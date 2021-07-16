[![Renku Docker Image CI](https://github.com/SwissDataScienceCenter/renkulab-docker/workflows/Renku%20Docker%20Image%20CI/badge.svg)](https://github.com/SwissDataScienceCenter/renkulab-docker/actions?query=workflow%3A%22Renku+Docker+Image+CI%22)

# RenkuLab Docker Images

RenkuLab Docker images contain minimal dependencies for launching interactive
environments like JupyterLab and RStudio from the Renku platform. They also each
contain a version of the [renku cli](https://github.com/SwissDataScienceCenter/renku-python).

## Usage

The basic python (renkulab-py), basic R (renkulab-r), and basic Julia (renkulab-julia)
images are available via
[renku project templates](https://github.com/SwissDataScienceCenter/renku-project-template)
that you select upon renku project creation on the RenkuLab platform, or locally
via `renku init`.

If you would like to use an image built from this repo that is
not available via the renku project templates, follow these steps:

* create your project with the minimal template that matches the programming
  language you're using (there's also a minimal template for languages other than
  python or R)
* replace the image in the `FROM` line in your project's Dockerfile with one of
  the images built from this repo. See "Naming Conventions" for how to choose
  which image to use

If you would like to add the ability to launch RenkuLab interactive environments
to your own pre-existing images, see the **Adding renku to your own images** section
below.


## Container initialization

Sometimes certain actions need to be performed on container start-up to prepare
the environment. Some of these are carried out already in the `entrypoint.sh`
script in the base image, but if you extend the image you may want to add your
own. This can be done by adding a `post-init.sh` script to the root directory of
the container. It must be executable by a non-privileged user because it will
run with the user restrictions of the container.

Projects using the base images may additionally place a `post-init.sh` script in
the root directory of the _project_. This script will also run upon initialization
of the container, but _after_ the `/entrypoint.sh` and `/post-init.sh` scripts.


## Naming Conventions

You can find these base images on
[DockerHub](https://hub.docker.com/search?q=renku%2Frenkulab-&type=image) in
`renku/renkulab-*` repositories, where `*` represents the "flavor" (programming
language or base image). Read the following naming conventions below to select
the image that's right for you:

`renku/renkulab-[image flavor]:[image flavor version]-[tag|hash]`

For example:
`renku/renkulab-py:3.8-0.7.0`

* `renku/renkulab`: indicates this is an image you can use to spawn an environment
  from your project on RenkuLab.
* `-py`: indicates this is a python image flavor; either the programming language
  installed in the environment, or the base image that extra dependencies are added to.
  See below for details about the available flavors.
* `3.8`: indicates the version of python is 3.7
* `0.7.0` (or `d572e9a`): the tag is a value given to a commit of the repository
  and indicates that the version is part of a release. If the version is not part of
  a release, this value is the first few chars of the git commit SHA from which the
  image is built.

Note that the base images include the specified version of the `renku` CLI.
This can easily be overridden by installing another version with `pipx` in the container
or any Dockerfile that uses these images, e.g.

```bash
pipx install --force renku==<version>
```

## Current images

### Recent releases and the corresponding versions

| Release | Release Date | Python | R            | Julia | Bioconductor | Cuda TF |
|---------|--------------|--------|--------------|-------|--------------|---------|
| [0.8.0](https://github.com/SwissDataScienceCenter/renkulab-docker/releases/tag/0.8.0) | 9 July 2021 | [3.9](https://hub.docker.com/r/renku/renkulab-py/tags?page=1&ordering=last_updated&name=0.8.0)    | [4.0.3](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.3-0.8.0), [4.0.4](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.4-0.8.0), [4.0.5](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.5-0.8.0) | [1.6.1](https://hub.docker.com/r/renku/renkulab-julia/tags?page=1&ordering=last_updated&name=1.6.1-0.8.0) | [3.11](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_11-0.8.0), [3.12](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_12-0.8.0)   |  [CUDA 11.0.3, TF 2.5.0](https://hub.docker.com/r/renku/renkulab-cuda-tf/tags?page=1&ordering=last_updated&name=0.8.0)                 |
| [0.7.7](https://github.com/SwissDataScienceCenter/renkulab-docker/releases/tag/0.7.7) | 10 June 2021 | [3.8](https://hub.docker.com/r/renku/renkulab-py/tags?page=1&ordering=last_updated&name=0.7.7)    | [4.0.3](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.3-0.7.7), [4.0.4](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.4-0.7.7), [4.0.5](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.5-0.7.7) | [1.6.1](https://hub.docker.com/r/renku/renkulab-julia/tags?page=1&ordering=last_updated&name=1.6.1-0.7.7) | [3.11](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_11-0.7.7), [3.12](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_12-0.7.7)   |  [CUDA 11.0.3, TF 2.4](https://hub.docker.com/r/renku/renkulab-cuda-tf/tags?page=1&ordering=last_updated&name=0.7.7)                 |
| [0.7.6](https://github.com/SwissDataScienceCenter/renkulab-docker/releases/tag/0.7.6) | 10 May 2021 | [3.8](https://hub.docker.com/r/renku/renkulab-py/tags?page=1&ordering=last_updated&name=0.7.6)    | [4.0.3](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.3-0.7.6), [4.0.4](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.4-0.7.6) | [1.6.1](https://hub.docker.com/r/renku/renkulab-julia/tags?page=1&ordering=last_updated&name=1.6.1-0.7.6) | [3.11](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_11-0.7.6), [3.12](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_12-0.7.6)   |  [CUDA 11.0.3, TF 2.4](https://hub.docker.com/r/renku/renkulab-cuda-tf/tags?page=1&ordering=last_updated&name=0.7.6)                 |
| [0.7.5](https://github.com/SwissDataScienceCenter/renkulab-docker/releases/tag/0.7.5) | 6 Apr 2021  | [3.8](https://hub.docker.com/r/renku/renkulab-py/tags?page=1&ordering=last_updated&name=0.7.5)    | [4.0.3](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.3-0.7.5), [4.0.4](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.4-0.7.5) | [1.5.3](https://hub.docker.com/r/renku/renkulab-julia/tags?page=1&ordering=last_updated&name=1.5.3-0.7.5) | [3.11](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_11-0.7.5), [3.12](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_12-0.7.5)   | [CUDA 11.0.3, TF 2.4](https://hub.docker.com/r/renku/renkulab-cuda-tf/tags?page=1&ordering=last_updated&name=0.7.5)    |
| [0.7.4](https://github.com/SwissDataScienceCenter/renkulab-docker/releases/tag/0.7.4) | 10 Feb 2021 | [3.7](https://hub.docker.com/r/renku/renkulab-py/tags?page=1&ordering=last_updated&name=0.7.4)    | [4.0.0](https://hub.docker.com/r/renku/renkulab-r/tags?page=1&ordering=last_updated&name=4.0.0-0.7.4)        | [1.5.3](https://hub.docker.com/r/renku/renkulab-julia/tags?page=1&ordering=last_updated&name=1.5.3-0.7.4) | [3.11](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_11-0.7.4), [3.12](https://hub.docker.com/r/renku/renkulab-bioc/tags?page=1&ordering=last_updated&name=RELEASE_3_12-0.7.4)   | -      |

### py

**Available via renku project templates**

The basic Jupyter image with minimal dependencies. Based on https://hub.docker.com/r/jupyter/base-notebook/.

dockerhub: https://hub.docker.com/r/renku/renkulab-py/tags

### r

**Available via renku project templates**

Based on the rocker "verse" image: https://hub.docker.com/r/rocker/verse,
chosen because rocker keeps a more up-to-date version of R than conda,
and includes most of the software dependencies that R users use.
Includes the R Jupyter kernel as well as RStudio. To access RStudio,
simply replace `/lab` or `/tree` with `/rstudio` in the URL.

dockerhub: https://hub.docker.com/r/renku/renkulab-r/tags

### julia

**Available via renku project templates**

Based on the renkulab-py (python 3.9) image with julia installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-julia/tags

### bioc

**Available via renku project templates**

Based on the bioconductor Docker image: https://github.com/Bioconductor/bioconductor_docker.

dockerhub: https://hub.docker.com/r/renku/renkulab-bioc/tags

### cuda-tf

Based on the renkulab-py (python 3.9) with CUDA 11.0.3 and Tensorflow 2.4 installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-cuda-tf/tags

### vnc

Based on the renkulab-py (python 3.9) with a full virtual desktop installed.
It uses noVNC 1.1.0 and TigerVNC 1.9.0 with a Renku UI to deliver a Linux desktop.

https://hub.docker.com/r/renku/renkulab-vnc/tags

## Development

Build with Docker by running `docker build -t <name:tag> .` in the directory
of the image you would like to build.

## Adding renku to your own images

If you already have a Docker image with complicated dependencies that are needed
for your work, you can get this up and running on RenkuLab by using one of our
Docker images in your build. We have two images that can be used in this way -
one that is completely generic, and the other that is specific to rocker-based
images.

Assuming you are in the directory with the Dockerfile you would like to use, you
can build the renkulab dependencies into it like this:

```
docker build -t <image-tag> \
  --build-arg BASE_IMAGE=<base-image> \
  https://github.com/SwissDataScienceCenter/renkulab-docker.git#docker/generic
```

where `image-tag` is some image name/tag you want to use and `base-image` is
your existing image.

If your own image is based on the rocker R distribution, you can do

```
docker build -t <image-tag> \
  --build-arg BASE_IMAGE=<base-image> \
  https://github.com/SwissDataScienceCenter/renkulab-docker.git#docker/r
```

## Contributing

If you have any suggestions for different languages or base images you would like
us to provide, feel free to submit an issue (or a pull request!) to this repo.
