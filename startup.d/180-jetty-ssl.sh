#!/bin/bash
# This creates a Jetty keystore by importing the standard PEM certificates and keys

if [ "$CONFIG_EXT_SSL_HOSTNAME" == "" ]; then
  exit
fi

keystore_path=$VAR_DIR/certs/jetty.keystore

[ -f $keystore_path ] && exit

source $APPS_DIR/etc/ssl_vars.inc

cert_path=$VAR_DIR/certs/$CERT_PEM
cert_key=$VAR_DIR/certs/$CERT_KEY

if [ ! -f $cert_path -o ! -f $cert_key ]; then
  echo ERROR: Either "$cert_path" or "$cert_key" seem to be missing - no SSL keys packaged
  exit 1
fi

# First, package up both certs 
cd $VAR_DIR/certs
openssl pkcs12 -inkey $cert_key -in $cert_path -export -out $cert_path.pkcs12 -passout "pass:$EXPORT_PASSWORD"

# Then create a new keystore
echo -e "$KEYSTORE_PASSWORD\n$KEYSTORE_PASSWORD\n$EXPORT_PASSWORD\n" | \
    $JAVA_HOME/bin/keytool -importkeystore -srckeystore $cert_path.pkcs12 -srcstoretype PKCS12 -destkeystore $keystore_path

# Get rid of PKCS12 package
rm $cert_path.pkcs12
