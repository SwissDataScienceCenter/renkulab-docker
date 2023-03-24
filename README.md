[![Renku Docker Image CI](https://github.com/SwissDataScienceCenter/renkulab-docker/workflows/Renku%20Docker%20Image%20CI/badge.svg)](https://github.com/SwissDataScienceCenter/renkulab-docker/actions?query=workflow%3A%22Renku+Docker+Image+CI%22)

# RenkuLab Docker Images

RenkuLab Docker images contain minimal dependencies for launching interactive
environments like JupyterLab and RStudio from the Renku platform. They also each
contain a version of the [renku cli](https://github.com/SwissDataScienceCenter/renku-python).

The images are available on
[DockerHub](https://hub.docker.com/search?q=renku%2Frenkulab-&type=image) and
are automatically built from this repo via github actions (see the `.github`
folder for more).

Images are updated from time to time; we try to keep them reasonably current
with modern python versions, cuda/torch versions and R versions. Typically, this
involves updating our github actions to include new versions and 
updating the `Makefile` to modify what it builds by default.

## Usage

The basic python (`renkulab-py`), basic R (`renkulab-r`), and basic Julia (`renkulab-julia`)
images are used in the 
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
`renku/renkulab-py:3.10-0.15.0`

* `renku/renkulab`: indicates this is an image you can use to spawn an environment
  from your project on RenkuLab.
* `-py`: indicates this is a python image flavor; either the programming language
  installed in the environment, or the base image that extra dependencies are added to.
  See below for details about the available flavors.
* `3.10`: indicates the version of python is 3.10
* `0.15.0` (or `d572e9a`): the tag is a value given to a commit of the repository
  and indicates that the version is part of a release. If the version is not part of
  a release, this value is the first few chars of the git commit SHA from which the
  image is built.

Note that the base images include the latest version of the `renku` CLI.
This can easily be overridden modifying the renku version in the project's Dockerfile.

## Current images

| Image                                                                          | Description                                     | Base image                                                                                         |
|--------------------------------------------------------------------------------|-------------------------------------------------|----------------------------------------------------------------------------------------------------|
| [renku/renkulab-py](https://hub.docker.com/r/renku/renkulab-py/tags)           | Jupyter image with minimal dependencies   | [jupyter/base-notebook](https://hub.docker.com/r/jupyter/base-notebook/tags)                       |
| [renku/renkulab-r](https://hub.docker.com/r/renku/renkulab-r/tags)             | Rstudio image                             | [rocker/verse](https://hub.docker.com/r/rocker/verse/tags)                                         |
| [renku/renkulab-julia](https://hub.docker.com/r/renku/renkulab-julia/tags)     | Julia image                               | [renku/renkulab-py](https://hub.docker.com/r/renku/renkulab-py/tags)                               |
| [renku/renkulab-cuda](https://hub.docker.com/r/renku/renkulab-cuda/tags)       | Cuda image with Python and minimal dependencies | [renku/renkulab-py](https://hub.docker.com/r/renku/renkulab-py/tags)                               |
| [renku/renkulab-cuda-tf](https://hub.docker.com/r/renku/renkulab-cuda-tf/tags) | Cuda image with Python and Tensorflow           | [renku/renkulab-cuda](https://hub.docker.com/r/renku/renkulab-cuda/tags)                           |
| [renku/renkulab-vnc](https://hub.docker.com/r/renku/renkulab-vnc/tags)         | VNC Image with Python                           | [renku/renkulab-py](https://hub.docker.com/r/renku/renkulab-py/tags)                               |
| [renku/renkulab-matlab](https://hub.docker.com/r/renku/renkulab-matlab/tags)   | VNC Image with Matlab                           | [renku/renkulab-py](https://hub.docker.com/r/renku/renkulab-py/tags)                               |
| [renku/renkulab-qgis](https://hub.docker.com/r/renku/renkulab-qgis/tags)       | VNC Image with QGIS                             | [renku/renkulab-py](https://hub.docker.com/r/renku/renkulab-py/tags)                               |

Please refer to the [release notes](https://github.com/SwissDataScienceCenter/renkulab-docker/releases)
for more detailed lists of released images and specific links to Dockerhub.

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

Based on the renkulab-py image with julia installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-julia/tags

### cuda

Based on the `renkulab-py` with different versions of python and CUDA installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-cuda/tags

### vnc

Based on the `renkulab-py` image with a full virtual desktop installed.
It uses noVNC 1.1.0 and TigerVNC 1.9.0 with a Renku UI to deliver a Linux desktop.

https://hub.docker.com/r/renku/renkulab-vnc/tags

### matlab

A full virtual desktop as above with matlab installed.

https://hub.docker.com/r/renku/renkulab-matlab/tags

### qgis

A full virtual desktop as above with QGIS installed.

https://hub.docker.com/r/renku/renkulab-qgis/tags

## Development

### Building images using `make`

A `Makefile` is provided in this directory which can be used to build the
images locally; you can build all images using `make all` or can build
individual images as required. `make` targets are also provided for pushing
and pulling images if needed.

### Building images using `docker`

It may be necessary to build individual images directly with `docker`; this
is done by running `docker build -t <name:tag> .` in the directory of the 
image you would like to build. Note that on arm-based systems (e.g. Apple 
M1/M2) you may need to use the flag `--platform=linux/amd64` for the
build because not all base images are available for ARM architecture. 

### M1/M2 (arm64) support
Starting with 0.16.0, the python base images are built to support both `X86_64`
and `arm64` architectures. If you need to build a multi-arch image locally, you can
do it with `make`:

```
$ PLATFORM=linux/amd64,linux/arm64 USE_BUILDX=1 make py
```

Alternatively you can use the `buildx` command directly:

```
$ docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag myimage:tag \
  --push \
  docker/py

Note that for the time being we can only provide the python images with `arm64` support. 

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
