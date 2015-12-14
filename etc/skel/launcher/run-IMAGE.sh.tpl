#!/bin/bash
#Extracted from %(PARENT_IMAGE) on %(`date`)

# Run as interactive: ./%(DEFAULT_LAUNCHER) [options]
#          or daemon: ./%(DEFAULT_LAUNCHER) -d [options]

IMAGE="%(PARENT_IMAGE)"
INTERACTIVE_SHELL="/bin/bash" 	# used if -d is not specified

EXT_HOSTNAME=%(CONFIG_EXT_HOSTNAME:-localhost)
EXT_PORT=8443

# Number of seconds to refresh authorized_keys files.  Set to 0 for no refresh.
AUTHKEYS_REFRESH=120

# Ping SSH servers this often as a keep alive
SERVER_ALIVE_SECS=60

# Enable two-factor authentication (either 'optional', 'required', 'disabled')
CONFIG_OTP=optional

# Enable key management.  If 'false' then this is just a bastion host for shell access.
ENABLE_KEY_MANAGEMENT=true

# If 'true', then users will be forced to generate new SSL keys.  If 'false', they can
# provide their own keys by cutting-and-pasting their public key.  (They can't currently
# do both).
FORCE_KEY_GENERATION=true

# If 'true', then enable the internal auditing log
ENABLE_INTERNAL_AUDIT=false
# When internal auditing is enabled, this determines how many days audit entries will be kept
DELETE_AUDIT_AFTER=90

# LOGGING Can be set to:
#   stdout      - all logging goes to stdout (the docker way)
#   file        - all logging goes to a var/log/syslog.log on attached storage
#   syslog:host - all logging goes to the syslog host
LOGGING=stdout

# If you want to run over HTTP rather than HTTPD, then set EXT_SSL_HOSTNAME to "" below, and choose a
# port for HTTP traffic.   KeyBox does not support both.
#EXT_SSL_HOSTNAME=""
#EXT_PORT=8080

# If this directory exists and is writable, then it will be used
# as attached storage
STORAGE_LOCATION="$PWD/%(IMAGE_BASENAME)-storage"
STORAGE_USER="$USER"

# Docker options

OPTIONS="\
  -e CONFIG_LOGGING=$LOGGING \
  -e CONFIG_EXT_HOSTNAME=$EXT_HOSTNAME \
  -e CONFIG_EXT_SSL_HOSTNAME=${EXT_SSL_HOSTNAME:-$EXT_HOSTNAME} \
  -e CONFIG_ENABLE_KEY_MANAGEMENT=$ENABLE_KEY_MANAGEMENT \
  -e CONFIG_FORCE_KEY_GENERATION=$FORCE_KEY_GENERATION \
  -e CONFIG_ENABLE_INTERNAL_AUDIT=$ENABLE_INTERNAL_AUDIT \
  -e CONFIG_OTP=$CONFIG_OTP \
  -e CONFIG_SERVER_ALIVE_SECS=$SERVER_ALIVE_SECS \
  -e CONFIG_DELETE_AUDIT_AFTER=$DELETE_AUDIT_AFTER \
  -p $EXT_PORT:8443"

# The rest should be OK...

if [ "$1" == '-d' ]; then
  shift
  docker_opt="-d $OPTIONS"
  INTERACTIVE_SHELL=""
else
  docker_opt="-t -i -e TERM=$TERM --rm=true $OPTIONS"
fi


if [ "$STORAGE_LOCATION" != "" -a -d "$STORAGE_LOCATION" -a -w "$STORAGE_LOCATION" ]; then
  SELINUX_FLAG=$(sestatus 2>/dev/null | fgrep -q enabled && echo :z)
  docker_opt="$docker_opt -v $STORAGE_LOCATION:/apps/var$SELINUX_FLAG"
  chap_opt="--create $STORAGE_USER:/apps/var"
  echo Using attached storage at $STORAGE_LOCATION
fi

docker run $docker_opt $IMAGE $chap_opt $* $INTERACTIVE_SHELL
