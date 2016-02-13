#!/bin/bash

#Now set in Dockerfile
#KEYBOX_VERSION=2.84_00

KEYBOX_URL=https://github.com/skavanagh/KeyBox/releases/download/v${KEYBOX_VERSION/_/.}/keybox-jetty-v$KEYBOX_VERSION.tar.gz

function relpath() { python3 -c "import os,sys;print(os.path.relpath(*(sys.argv[1:])))" "$@"; }

cd /setup

# add additional software needed for SSL key generation and maintenance
apk --update add openssl

# remove existing chaperone.d and startup.d from /apps so none linger
rm -rf /apps; mkdir /apps

# copy everything from setup to the root /apps
echo copying application files to /apps ...
tar cf - --exclude .git --exclude Dockerfile --exclude ./build --exclude ./build.sh --exclude ./run.sh \
    --exclude var --exclude KeyBox-jetty . \
    | (cd /apps; tar xf -)

# update version in the image
sed "s/^KEYBOX_VERSION=.*/KEYBOX_VERSION=$KEYBOX_VERSION/" </setup/etc/version.inc >/apps/etc/version.inc

# Get Keybox and install it

cd /setup
wget --progress=dot:mega --no-check-certificate $KEYBOX_URL

cd /apps
tar xzf /setup/keybox-jetty-v$KEYBOX_VERSION.tar.gz

# Move config files to our shared location unless they are already there (this could occur
# on an upgrade or rebuild)

JETTY=/apps/KeyBox-jetty/jetty

# These won't exist until runtime but we define here because it simplifies
# assuring relative paths are correct.
VAR_KBCONFIG=/apps/var/config/KeyBoxConfig.properties
VAR_JETTY_START=/apps/var/config/jetty-start.ini
VAR_L4JCONFIG=/apps/var/config/log4j.xml

# We need to create a symlink to the /var/config/KeyBoxConfig.properties file, since this
# will need to be writable.  But, the actual location may vary based upon container
# configuration.

cd $JETTY/keybox/WEB-INF/classes
rm -rf KeyBoxConfig.properties
ln -s $(relpath $VAR_KBCONFIG)

# same with the log4j config

cd $JETTY/keybox/WEB-INF/classes
rm -rf log4j.xml
ln -s $(relpath $VAR_L4JCONFIG)

# Same with jetty startup so we can put the keystore in attached storage

cd $JETTY
rm -rf start.ini
ln -s $(relpath $VAR_JETTY_START) start.ini

# Move/replace the initial database directory to etc so we can initialize /var whenever a container
# starts.

cd $JETTY/keybox/WEB-INF/classes
rm -rf /apps/etc/keydb-dist
mv keydb /apps/etc/keydb-dist
ln -s $(relpath /apps/var/keydb)

# General cleanup
cd /
rm -rf /setup /tmp/* /var/tmp/* /var/cache/apk/* /root/.cache
chown -R runapps: /apps    # for full-container execution
