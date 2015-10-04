#!/bin/bash

# This script is used to do diff-based updates to this image based
# upon the template scripts in the original chaperone-alpinejava
# image.  Usually, there is no reason to do this, as most of the 
# scripts have been highly customized, but if you really want to
# get some new features that are important, this can help.

# Run me from etc, I assume the main directory is above us
cd ..

docker run -i -t --rm -v /home:/home chapdev/chaperone-alpinejava \
  --create-user $USER:$PWD/chaperone.d --config $PWD/chaperone.d \
  --task apps-update /apps $PWD
