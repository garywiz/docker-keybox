FROM chapdev/chaperone-alpinejava
ADD . /setup/
ENV KEYBOX_VERSION=2.84_01
RUN /setup/build/install.sh
EXPOSE 8443
