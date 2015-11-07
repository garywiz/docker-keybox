#!/bin/bash
#Created by chaplocal on %(`date`)
# the cd trick assures this works even if the current directory is not current.

cd ${0%/*}
if [ "$CHAP_SERVICE_NAME" != "" ]; then
  echo You need to run build.sh on your docker host, not inside a container.
  exit
fi

# Uncomment to default to your new derivative image name...
#prodimage="%(PARENT_IMAGE:|chapdev/*|%(PARENT_IMAGE:/^chapdev/mylocal/)|%(PARENT_IMAGE))"

[ "$1" != "" ] && prodimage="$1"

if [ "$prodimage" == "" ]; then
  echo "Usage: ./build.sh <production-image-name>"
  exit 1
else
  echo Building "$prodimage" ...
fi

if [ ! -f Dockerfile ]; then
  echo "Expecting to find Dockerfile in current directory ... not found!"
  exit 1
fi

# Update the image information for the new build
sed "s/^IMAGE_NAME=.*/IMAGE_NAME=${prodimage/\//\\\/}/" <etc/version.inc >build/new_version.inc

# Do the build
docker build -t $prodimage .

