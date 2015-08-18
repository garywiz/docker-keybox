#!/bin/bash

function relpath() { python3 -c "import os,sys;print(os.path.relpath(*(sys.argv[1:])))" "$@"; }

cd /setup

# remove existing chaperone.d and startup.d from /apps so none linger
rm -rf /apps; mkdir /apps

# copy everything from setup to the root /apps
echo copying application files to /apps ...
tar cf - --exclude var --exclude KeyBox-jetty . | (cd /apps; tar xf -)

# If there is an 100-install.sh executable script available in startup.d, then incorporate
# it into our image build and comment them out so the next build documents, but does not
# include them.

if [ -x startup.d/100-install.sh ]; then
  # Execute these
  ./startup.d/100-install.sh BUILD
  # Comment them out so the install file can be incrementally used again.
  sed -r '/AFTER THIS LINE/,$ s/^[ \t]*[^# \t].*/#\0/' startup.d/100-install.sh >/apps/startup.d/100-install.sh
fi

# Add additional setup commands for your production image here, if any.  However, the best
# way is to put things in 100-install.sh.
# ...
n
cd /setup

wget --progress=dot:mega --no-check-certificate https://github.com/skavanagh/KeyBox/releases/download/v2.83.02/keybox-jetty-v2.83_02.tar.gz

cd /apps
tar xzf /setup/keybox-jetty-v2.83_02.tar.gz

# Move config files to our shared location unless they are already there (this could occur
# on an upgrade or rebuild)

JETTY=/apps/KeyBox-jetty/jetty
ETC_JETTY_START=/apps/etc/jetty-start.ini
VAR_KBCONFIG=/apps/var/keydb/KeyBoxConfig.properties

if [ ! -f $ETC_JETTY_START ]; then
  cd $JETTY
  mv start.ini $ETC_JETTY_START
  ln -s $(relpath $ETC_JETTY_START) start.ini
fi

# We need to create a symlink to the /var/keydb/KeyBoxConfig.properties file, since this
# will need to be writable.  But, the actual location may vary based upon container
# configuration.

cd $JETTY/keybox/WEB-INF/classes
rm -rf KeyBoxConfig.properties
ln -s $(relpath $VAR_KBCONFIG)

# Move/replace the initial database directory to etc so we can initialize /var whenever a container
# starts.

rm -rf /apps/etc/keydb-dist
mv keydb /apps/etc/keydb-dist
ln -s $(relpath /apps/var/keydb)

rm -rf /setup
chown -R runapps: /apps    # for full-container execution
