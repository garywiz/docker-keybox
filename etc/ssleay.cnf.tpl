#
# SSLeay example configuration file.
#

RANDFILE                = /dev/urandom

[ req ]
default_bits            = 2048
default_keyfile         = privkey.pem
distinguished_name      = req_distinguished_name
prompt                  = no
policy			= policy_anything
req_extensions          = v3_req
x509_extensions         = v3_req

[ req_distinguished_name ]
commonName              = %(CONFIG_EXT_SSL_HOSTNAME)
organizationName        = KeyBox Docker Image
countryName             = US

[ v3_req ]
basicConstraints        = CA:FALSE