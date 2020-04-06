[![Renku Docker Image CI](https://github.com/SwissDataScienceCenter/renkulab-docker/workflows/Renku%20Docker%20Image%20CI/badge.svg)](https://github.com/SwissDataScienceCenter/renkulab-docker/actions?query=workflow%3A%22Renku+Docker+Image+CI%22)

[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

# Renkulab Docker Images

Renkulab Docker Images contain minimal dependencies for launching interactive
environments like Jupyterlab and RStudio from the Renku platform. They also each
contain a version of the [renku cli](https://github.com/SwissDataScienceCenter/renku-python).

## Usage

The basic python (py3.7) and basic R (r) images are available via
[renku project templates](https://github.com/SwissDataScienceCenter/renku-project-template)
that you select upon renku project creation on the renkulab platform, or locally
via `renku init`. If you would like to use an image built from this repo that is
not available via the renku project templates, follow these steps:

* create your project with the minimal template that matches the programming
  language you're using (there's also a minimal template for languages other than
  python or R)
* replace the image in the `FROM` line in your project's Dockerfile with one of
  the images built from this repo. See "Naming Conventions" for how to choose
  which image to use

## Naming Conventions

Images in https://hub.docker.com/r/renku/renkulab/tags follow the following naming
conventions to help you know which image to choose for your renku project:

`renku/renkulab:renku[renku-python version]-[image flavor][image flavor version]-[tag|hash]`

For example:
`renku/renkulab:renku0.10.2-py3.7-1.6.1`

* `renku/renkulab`: indicates this is an image you can use to spawn an environment
  from your project on Renkulab.
* `renku[renku version]` (e.g. `renku0.10.2`): indicates the version of the
  renku CLI installed in the image. Note: if no version is present, it's the latest
  available development version.
* `[image flavor][image flavor version]` (e.g. `r3.6.3`): image flavor refers either
  to the programming language installed in the environment, or the base image that
  extra dependencies are added to. See below for details about the available flavors.
* `[tag|hash]` (e.g. `1.6.1`): the tag is a value given to a commit of the repository
  and indicates that the version is part of a release. If the version is not part of
  a release, this value is the first few chars of the git commit SHA from which the
  image is built.

## Current images

### py3.7

**Available via renku project templates**

The basic Jupyter image with minimal dependencies. Based on https://hub.docker.com/r/jupyterhub/singleuser.

Currently with python 3.7.

### r

**Available via renku project templates**

Based on the rocker docker image: https://github.com/rocker-org/binder,
chosen because rocker keeps a more up-to-date version of R than conda.
Includes the R Jupyter kernel as well as RStudio. To access RStudio,
simply replace `/lab` or `/tree` with `/rstudio` in the URL.

Several versions of R are available, including the latest 3.6.3.

### bioc

Based on the bioconductor docker image: https://github.com/Bioconductor/bioconductor_docker.

Currently with bioconductor 3_10 & devel.

### cuda9.2

Based on the py3.7 image with CUDA 9.2 installed.

### cuda10.0-tf1.14

Based on the py3.7 with CUDA 10.0 and Tensorflow 1.14 installed.

### julia1.3.1

The basic Jupyter image with Julia installed. Based on https://hub.docker.com/r/jupyterhub/singleuser.

Currently with julia 1.3.1.

## Development

Build with Docker by running `docker build -t <name:tag> .` in the directory
of the image you would like to build.

## Contributing

If you have any suggestions for different languages or base images you would like
us to provide, feel free to submit an issue (or a pull request!) to this repo.
