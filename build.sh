#!/bin/bash

# Will create a new KeyBox image.  Can also use "docker build" directly.  This just handles tagging
# and simplifies construction.

. etc/version.inc

cd ${0%/*}
if [ "$CHAP_SERVICE_NAME" != "" ]; then
  echo You need to run build.sh on your docker host, not inside a container.
  exit
fi
prodimage="$IMAGE_NAME:$KEYBOX_VERSION"
if [ "$1" != "" ]; then
  prodimage="$1"
fi
if [ ! -f Dockerfile ]; then
  echo "Expecting to find Dockerfile in current directory ... not found!"
  exit 1
fi
docker build -t $prodimage .
docker tag -f $prodimage $IMAGE_NAME:latest
