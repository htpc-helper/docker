# Login to Docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Install build deps
if [ "$ARCH" == "armv7" ]; then
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
  curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v2.6.0/qemu-arm-static.tar.gz
  tar xzf qemu-arm-static.tar.gz
  # Configure image to download
  alpineUrl="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/"
  rootfsfile="alpine-minirootfs-3.7.0-armhf.tar.gz"
elif [ "$ARCH" == "x86_64" ]; then
  # Configure image to download
  alpineUrl="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/"
  rootfsfile="alpine-minirootfs-3.7.0-x86_64.tar.gz"
fi

# Download OS files
signaturefile="$rootfsfile.sha512"
wget $alpineUrl$rootfsfile
wget $alpineUrl$signaturefile

# Compare checksums
CS_DL=`sha512sum $rootfsfile`
CS_FILE=`cat $signaturefile`
if [ "$CS_DL" == "$CS_FILE" ]; then
  echo "Signatures match, file will now be renamed"
  mv $rootfsfile rootfs.tar.xz
fi

# Build image
docker build -t $DOCKER_USERNAME/$IMAGE -f ./Dockerfile_$ARCH .

# Tag image and upload to Dockerhub
docker images
docker tag $DOCKER_USERNAME/$IMAGE $DOCKER_USERNAME/$IMAGE:$ARCH
docker push $DOCKER_USERNAME/$IMAGE:$ARCH
