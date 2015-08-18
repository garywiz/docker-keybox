FROM chapdev/chaperone-alpinejava
ADD . /setup/
#Used to specify the default chaplocal image
ENV _PARENT_IMAGE="garywiz/docker-keybox"
RUN /setup/build/install.sh
EXPOSE 8443
