Help for Image: %(PARENT_IMAGE) Version %(IMAGE_VERSION) 
        KeyBox: %(KEYBOX_VERSION)
     Chaperone: %(`chaperone --version | awk '/This is/{print $5}'`)
   Oracle Java: %(`java -version 2>&1 | sed -n -e 's|.*"\(.*\)"|\1|p'`)
         Linux: %(`cat /etc/issue | head -1 | sed -e 's/Welcome to //' -e 's/ \\.*$//'`)

This docker image provides a fully-configurable KeyBox implementation.
You can find out more about configuration and how to use this image at:

    https://github.com/garywiz/docker-keybox

You can run a self-contained version of KeyBox by simply running this image:

  $ docker run -d -p 8443:8443 %(PARENT_IMAGE)

When you do, you should have KeyBox running at https://localhost:8443.

However, it's much better to ask the image to give you a copy of the
standard launcher script:

  $ docker run -i --rm %(PARENT_IMAGE) --task get-launcher | sh

You will then have a script called %(DEFAULT_LAUNCHER) which allows you
to keep the keys, certificates, and other data in attached storage.

So, if you say:
    mkdir docker-keybox-storage
    ./%(DEFAULT_LAUNCHER) -d

Keybox will run as a daemon and all persistent data will be stored
in the 'docker-keybox-storage' directory.

The launcher is highly customizable and if you read it, you will see
all relevant KeyBox configuration variables.  You can also put your own
SSL keys in attached storage so your KeyBox site will be served with
a proper SSL certificate.
