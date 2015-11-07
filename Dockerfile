FROM chapdev/chaperone-alpinejava

ADD . /setup/

# Git tag version number format should be '2.84.01'.  This will trigger an automated build.
# The following version format is used within the Keybox distribution filename.
ENV KEYBOX_VERSION=2.84_01

RUN /setup/build/install.sh
EXPOSE 8443
