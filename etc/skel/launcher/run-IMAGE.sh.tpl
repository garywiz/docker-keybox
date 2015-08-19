#!/bin/bash
#Extracted from %(PARENT_IMAGE) on %(`date`)

# Run as interactive: ./%(DEFAULT_LAUNCHER) [options]
#          or daemon: ./%(DEFAULT_LAUNCHER) -d [options]

IMAGE="%(PARENT_IMAGE)"
INTERACTIVE_SHELL="/bin/bash" 	# used if -d is not specified

EXT_HOSTNAME=%(CONFIG_EXT_HOSTNAME:-localhost)
EXT_HTTPD_PORT=8443

# Number of seconds to refresh authorized_keys files.  Set to 0 for no refresh.
AUTHKEYS_REFRESH=120

# Enable two-factor authentication
ENABLE_OTP=true

# Enable key management.  If 'false' then this is just a bastion host for shell access.
CONFIG_ENABLE_KEY_MANAGEMENT=true

# LOGGING Can be set to:
#   stdout      - all logging goes to stdout (the docker way)
#   file        - all logging goes to a var/log/syslog.log on attached storage
#   syslog:host - all logging goes to the syslog host
LOGGING=stdout

# If this directory exists and is writable, then it will be used
# as attached storage
STORAGE_LOCATION="$PWD/%(IMAGE_BASENAME)-storage"
STORAGE_USER="$USER"

# Docker options

OPTIONS="-e CONFIG_LOGGING=$LOGGING -e CONFIG_EXT_HTTPD_PORT=$EXT_HTTPD_PORT -p $EXT_HTTPD_PORT:8443"

# The rest should be OK...

if [ "$1" == '-d' ]; then
  shift
  docker_opt="-d $OPTIONS"
  INTERACTIVE_SHELL=""
else
  docker_opt="-t -i -e TERM=$TERM --rm=true $OPTIONS"
fi


if [ "$STORAGE_LOCATION" != "" -a -d "$STORAGE_LOCATION" -a -w "$STORAGE_LOCATION" ]; then
  docker_opt="$docker_opt -v $STORAGE_LOCATION:/apps/var"
  chap_opt="--create $STORAGE_USER:/apps/var"
  echo Using attached storage at $STORAGE_LOCATION
fi

docker run $docker_opt $IMAGE $chap_opt $* $INTERACTIVE_SHELL
