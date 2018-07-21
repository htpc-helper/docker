#!/bin/bash

# Build image
docker build -t $DOCKER_USERNAME/$IMAGE -f ./Dockerfile_$ARCH .

# Tag image and upload to Dockerhub
docker images
docker tag $DOCKER_USERNAME/$IMAGE $DOCKER_USERNAME/$IMAGE:$ARCH
docker push $DOCKER_USERNAME/$IMAGE:$ARCH
# docker tag htpchelper/logstash htpchelper/alpine-logstash
# docker push htpchelper/alpine-logstash
