#!/bin/bash

# Login to Docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
# Install build deps
if [ $ARCH == "armv7" ]; then
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi;
# Build image
docker build -t $DOCKER_USERNAME/$IMAGE -f ./Dockerfile_$ARCH .
# Tag image and upload to Dockerhub
docker images
docker tag $DOCKER_USERNAME/$IMAGE $DOCKER_USERNAME/$IMAGE:$ARCH
docker push $DOCKER_USERNAME/$IMAGE:$ARCH
