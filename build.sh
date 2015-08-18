#!/bin/bash

# Will create a new KeyBox image

cd ${0%/*}
if [ "$CHAP_SERVICE_NAME" != "" ]; then
  echo You need to run build.sh on your docker host, not inside a container.
  exit
fi
prodimage="garywiz/docker-keybox"
if [ "$1" != "" ]; then
  prodimage="$1"
fi
if [ ! -f build/Dockerfile ]; then
  echo "Expecting to find Dockerfile in ./build ... not found!"
  exit 1
fi
tar czh --exclude '*~' --exclude 'var/*' --exclude 'KeyBox-jetty/*' . | docker build -t $prodimage -f build/Dockerfile -
