#!/bin/sh

export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx version
# binfmt_misc
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
docker buildx create --use --name mut-arc-builder
docker buildx inspect mut-arc-builder --bootstrap

# build
docker buildx build -t binacslee/novnc-base --platform=linux/amd64,linux/arm64,linux/386,linux/arm/v7 . --push
docker buildx imagetools inspect binacslee/novnc-base


# FOR LOCAL TEST
# # # build from local Dockerfile
# # docker build --no-cache -t binacslee/test .
# #
# # docker run -it --rm -v $PWD:/work -w /work -p 10000:10000 \
# #     --name test \
# #     binacslee/test