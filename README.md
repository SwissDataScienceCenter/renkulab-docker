[![Renku Docker Image CI](https://github.com/SwissDataScienceCenter/renkulab-docker/workflows/Renku%20Docker%20Image%20CI/badge.svg)](https://github.com/SwissDataScienceCenter/renkulab-docker/actions?query=workflow%3A%22Renku+Docker+Image+CI%22)

[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

# Renkulab Docker Images

Renkulab Docker Images contain minimal dependencies for launching interactive
environments like Jupyterlab and RStudio from the Renku platform. They also each
contain a version of the [renku cli](https://github.com/SwissDataScienceCenter/renku-python).

## Usage

The basic python (renkulab-py) and basic R (renkulab-r) images are available via
[renku project templates](https://github.com/SwissDataScienceCenter/renku-project-template)
that you select upon renku project creation on the renkulab platform, or locally
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

## Naming Conventions

You can find these base images on
[DockerHub](https://hub.docker.com/search?q=renku%2Frenkulab-&type=image) in
`renku/renkulab-*` repositories, where `*` represents the "flavor" (programming
language or base image). Read the following naming conventions below to select
the image that's right for you:

`renku/renkulab-[image flavor]:[image flavor version]-[tag|hash]`

For example:
`renku/renkulab-py:3.7-0.6.4`

* `renku/renkulab`: indicates this is an image you can use to spawn an environment
  from your project on Renkulab.
* `-py`: indicates this is a python image flavor; either the programming language
  installed in the environment, or the base image that extra dependencies are added to.
  See below for details about the available flavors.
* `3.7`: indicates the version of python is 3.7
* `0.6.4` (or `d572e9a`): the tag is a value given to a commit of the repository
  and indicates that the version is part of a release. If the version is not part of
  a release, this value is the first few chars of the git commit SHA from which the
  image is built.

Note that the latest version of the `renku` CLI is always installed in the base images.
This can easily be overriden by installing another version with `pipx` in the container
or any Dockerfile that uses these images, e.g.

```bash
pipx install --force renku==<version>
```

## Current images

### py3.7

**Available via renku project templates**

The basic Jupyter image with minimal dependencies. Based on https://hub.docker.com/r/jupyter/base-notebook/.

dockerhub: https://hub.docker.com/r/renku/renkulab-py/tags

Currently with python 3.7.

### r

**Available via renku project templates**

Based on the rocker "verse" image: https://hub.docker.com/r/rocker/verse,
chosen because rocker keeps a more up-to-date version of R than conda,
and includes most of the software dependencies that R users use.
Includes the R Jupyter kernel as well as RStudio. To access RStudio,
simply replace `/lab` or `/tree` with `/rstudio` in the URL.

dockerhub: https://hub.docker.com/r/renku/renkulab-r/tags

Several versions of R are available, including the latest, 4.0.0.

### bioc

Based on the bioconductor docker image: https://github.com/Bioconductor/bioconductor_docker.

dockerhub: https://hub.docker.com/r/renku/renkulab-bioc/tags

Currently with bioconductor 3_11, 3_10 & devel.

### cuda9.2

Based on the py3.7 image with CUDA 9.2 installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-cuda9.2/tags

### cuda10.0-tf1.14

Based on the py3.7 with CUDA 10.0 and Tensorflow 1.14 installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-cuda10.0-tf1.14/tags

### julia1.3.1

Based on the py3.7 image with julia installed.

dockerhub: https://hub.docker.com/r/renku/renkulab-julia1.3.1/tags

Currently with julia 1.3.1.

## Development

Build with Docker by running `docker build -t <name:tag> .` in the directory
of the image you would like to build.

## Adding renku to your own images

If you already have a docker image with complicated dependencies that are needed
for your work, you can get this up and running on renkulab by using one of our
docker images in your build. We have two images that can be used in this way -
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
