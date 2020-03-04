[![Build Status](https://travis-ci.com/SwissDataScienceCenter/renku-jupyter.svg?branch=master)](https://travis-ci.com/SwissDataScienceCenter/renku-jupyter)
[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

# Renku Jupyter images

This repository contains the Dockerfiles to build Jupyter notebook images
& other interactive environments to use with the Renku platform.
These images contain minimal dependencies as well as a verison of `renku-python`.
https://hub.docker.com/r/renku/renkulab/tags

## Building

Build with Docker by running `docker build -t <name:tag> .` in the directory
of the image you would like to build.

## Current images

### py3.7

The basic Jupyter image with minimal dependencies.

Currently with python 3.7.

### r3.6.1

Based on the rocker docker image: https://github.com/rocker-org/binder,
chosen because rocker keeps a more up-to-date version of R than conda.
Includes the R Jupyter kernel as well as RStudio. To access RStudio,
simply replace `/lab` or `/tree` with `/rstudio` in the URL.

Currently with R 3.6.1.

### bioc3_10

Based on the bioconductor docker image: https://github.com/Bioconductor/bioconductor_docker.

Currently with bioconductor 3_10.

### cuda9.2

Based on the basic jupyter image with CUDA 9.2 installed.

### cuda10.0-tf1.14

Based on the basic jupyter image with CUDA 10.0 and Tensorflow 1.14 installed.
