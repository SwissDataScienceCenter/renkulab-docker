ARG RENKU_BASE=renku/renkulab-py:latest
FROM $RENKU_BASE as base

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root
SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

# Julia dependencies and installation - adapted from https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
# If this changes, you also need to change the checksum below
ARG JULIA_VERSION_ARG=1.9.0
ENV JULIA_VERSION=${JULIA_VERSION_ARG}
ARG JULIA_CHECKSUM="00c614466ef9809c2eb23480e38d196a2c577fff2730c4f83d135b913d473359"

RUN mkdir /opt/julia-${JULIA_VERSION} && \
    wget -q -P /tmp/ "https://julialang-s3.julialang.org/bin/linux/x64/$(echo ${JULIA_VERSION} | cut -d. -f 1,2)/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" && \
    echo ${JULIA_CHECKSUM} /tmp/*julia-${JULIA_VERSION}-linux-x86_64.tar.gz | sha256sum -c - && \
    tar xzf /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia && \
    # Show Julia where conda libraries are \
    mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir "$JULIA_PKGDIR" && \
    chown "$NB_USER" "$JULIA_PKGDIR" && \
    fix-permissions "$JULIA_PKGDIR"

# switch to the notebook user
USER $NB_USER

RUN julia -e 'import Pkg; Pkg.update()' && \
    (test "$TEST_ONLY_BUILD" || julia -e 'import Pkg; Pkg.add("HDF5")') && \
    julia -e "using Pkg; pkg\"add IJulia\"; pkg\"precompile\"" && \
    # move kernelspec out of home \
    mv "$HOME"/.local/share/jupyter/kernels/julia* "$CONDA_DIR/share/jupyter/kernels/" && \
    chmod -R go+rx "$CONDA_DIR/share/jupyter" && \
    rm -rf "$HOME/.local/share/jupyter" && \
    fix-permissions "$JULIA_PKGDIR" "$CONDA_DIR/share/jupyter"

COPY post-init.sh /post-init.sh
