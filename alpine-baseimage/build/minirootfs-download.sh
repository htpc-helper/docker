#!/usr/bin/env bash

# Configure inputs
alpineUrl="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/"
rootfsfile="alpine-minirootfs-3.7.0-armhf.tar.gz"
signaturefile="$rootfsfile.sha512"

# Download files
wget $alpineUrl$rootfsfile
wget $alpineUrl$signaturefile

CS_DL=`sha512sum $rootfsfile`
CS_FILE=`cat $signaturefile`

# Compare checksums
if [ "$CS_DL" == "$CS_FILE" ]; then
  echo "Signatures match, file will now be renamed"
  mv $rootfsfile rootfs.tar.xz
fi
