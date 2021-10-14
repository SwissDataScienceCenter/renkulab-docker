# For finding latest versions of the base image see
# https://github.com/SwissDataScienceCenter/renkulab-docker
ARG RENKU_BASE_IMAGE=renku/renkulab-vnc:0.10.1
FROM ${RENKU_BASE_IMAGE}

USER root

# CUDA
ENV CUDA_VERSION=11.0.3
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda-11.0/lib64
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA=cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450
ENV NCCL_VERSION=2.10.3
ENV LIBRARY_PATH=/usr/local/cuda/lib64/stubs
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/conda/bin:/home/jovyan/.local/bin
    
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates \
    &&     curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - \
    &&     echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list \
    &&     echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list \
    &&     rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends cuda-cudart-11-0=11.0.221-1 cuda-compat-11-0 \
    &&     ln -s cuda-11.1 /usr/local/cuda \
    &&     rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    &&     echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

RUN apt-get update \
    && apt-get install -y --no-install-recommends cuda-libraries-11-0=11.0.3-1 libnpp-11-0=11.1.0.245-1 cuda-nvtx-11-0=11.0.167-1 libcublas-11-0=11.2.0.252-1 libcusparse-11-0=11.1.1.245-1 libnccl2=$NCCL_VERSION-1+cuda11.0 \
    &&     apt-mark hold libnccl2 \
    &&     rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends libtinfo5 libncursesw5 cuda-cudart-dev-11-0=11.0.221-1 cuda-command-line-tools-11-0=11.0.3-1 cuda-minimal-build-11-0=11.0.3-1 cuda-libraries-dev-11-0=11.0.3-1 cuda-nvml-dev-11-0=11.0.167-1 libnpp-dev-11-0=11.1.0.245-1 libnccl-dev=2.10.3-1+cuda11.0 libcublas-dev-11-0=11.2.0.252-1 libcusparse-dev-11-0=11.1.1.245-1 \
    &&     rm -rf /var/lib/apt/lists/*


# CUDNN Installation
ENV CUDNN_VERSION=8.1.0.77

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcudnn8=$CUDNN_VERSION-1+cuda11.0 libcudnn8-dev=$CUDNN_VERSION-1+cuda11.0 \
    &&     rm -rf /var/lib/apt/lists/*


# Extra things for DeepLabCut
RUN apt-get update \
    && apt-get remove libgtk2.0-dev \
    && apt-get install -y --no-install-recommends libgtk-3-dev python3-wxgtk4.0 locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 en_GB.UTF-8
    
ENV DLClight=False

RUN ln -s /usr/local/cuda-11.0/lib64/libcusolver.so.10 /usr/local/cuda-11.0/lib64/libcusolver.so.11

USER ${NB_USER}

COPY environment.yml /tmp/
RUN conda env update -q -f /tmp/environment.yml && \
#    /opt/conda/bin/pip install -r /tmp/requirements.txt && \
    conda clean -y --all && \
    conda env export -n "py38" && \
    /opt/conda/envs/py38/bin/python -m ipykernel install --user --name=py38 && \
    conda init bash && \
    echo "conda activate py38" >> ~/.bashrc 


# RENKU_VERSION determines the version of the renku CLI
# that will be used in this image. To find the latest version,
# visit https://pypi.org/project/renku/#history.
ARG RENKU_VERSION=0.16.2

########################################################
# Do not edit this section and do not add anything below

# Install renku from pypi or from github if it's a dev version
RUN if [ -n "$RENKU_VERSION" ] ; then \
        source .renku/venv/bin/activate ; \
        currentversion=$(renku --version) ; \
        if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
            pip uninstall renku -y ; \
            gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\3/p") ; \
            if [ -n "$gitversion" ] ; then \
                pip install --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
            else \
                pip install --force renku==${RENKU_VERSION} ;\
            fi \
        fi \
    fi

########################################################
