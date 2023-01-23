# Building images locally

When building these images locally, the biggest issue is finding the versions of the
CUDA libraries which you may need to install. You can find available versions when 
in Ubuntu using the following:

```
ubuntu@docker-cuda-build:~/renkulab-docker/docker/cuda$ apt list --all-versions libcudnn8
Listing... Done
libcudnn8/unknown 8.7.0.84-1+cuda11.8 amd64
libcudnn8/unknown 8.6.0.163-1+cuda11.8 amd64
libcudnn8/unknown 8.5.0.96-1+cuda11.7 amd64
```

```
ubuntu@docker-cuda-build:~/renkulab-docker/docker/cuda$ apt list --all-versions cuda-cudart-11-7
Listing... Done
cuda-cudart-11-7/unknown 11.7.99-1 amd64
cuda-cudart-11-7/unknown 11.7.60-1 amd64
```
