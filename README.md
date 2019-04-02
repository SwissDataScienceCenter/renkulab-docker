[![Build Status](https://travis-ci.com/SwissDataScienceCenter/renku-jupyter.svg?branch=master)](https://travis-ci.com/SwissDataScienceCenter/renku-jupyter)
[![pullreminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

# Renku Jupyter images

This repository contains the Dockerfiles to build Jupyter notebook images
to use with the Renku platform.


## Building

Building is done with `make`, e.g.

```
make base
```

will build the `renku/singleuser` image

or

```
make all
```

will build all the currently-supported images.

## Current images

### Base

The basic Jupyter image with minimal dependencies

### R

Includes the R Jupyter kernel as well as RStudio. To access RStudio,
simply replace `/lab` or `/tree` with `/rstudio` in the URL.

### Cuda

Image with CUDA 9.2 installed.
