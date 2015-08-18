#!/bin/bash

function relpath() { python3 -c "import os,sys;print(os.path.relpath(*(sys.argv[1:])))" "$@"; }

# Assure all external storage is in /apps/var

JETTY=$APPS_DIR/KeyBox-jetty/jetty
VAR_KEYDB=$VAR_DIR/keydb
VAR_KBCONFIG=$VAR_DIR/keydb/KeyBoxConfig.properties

# Assure all external storage and writable properties are in /apps/var
if [ ! -d $VAR_KEYDB ]; then
  cp -a $APPS_DIR/etc/keydb-dist $VAR_KEYDB
fi

# Process KeyBoxConfig.properties as a template, process it at startup, since each
# startup configuration may be different.
if [ ! -f $VAR_KBCONFIG ]; then
  tpl_envcp $APPS_DIR/etc/KeyBoxConfig.properties.tpl $VAR_KBCONFIG
fi

cd $APPS_DIR/KeyBox-jetty/jetty
java -Xms1024m -Xmx1024m -jar start.jar
