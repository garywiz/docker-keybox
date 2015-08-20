# Variables related to SSL configuration

# Set up defaults

export CERT_KEY=ssl-cert-${CONFIG_EXT_SSL_HOSTNAME}.key
export CERT_PEM=ssl-cert-${CONFIG_EXT_SSL_HOSTNAME}.pem   # Usually .crt or .pem file

export KEYSTORE_PASSWORD=kbox-kstore-pw
export EXPORT_PASSWORD=kbox-export-pw

# Allow user override
if [ -f $VAR_DIR/config/ssl_vars.inc ]; then
  source $VAR_DIR/config/ssl_vars.inc
fi
