# This is a template Dockerfile for creating a new image which is
# derived from %(PARENT_IMAGE).   Use this if you want to add features
# to %(PARENT_IMAGE) and create a new image based upon it.

FROM %(PARENT_IMAGE)
ADD . /setup/
RUN /setup/build/install.sh
