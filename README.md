#KeyBox Docker Image

KeyBox is an open-source web-based SSH console that centrally manages administrative access to systems. Web-based administration is combined with management and distribution of user's public SSH keys. Key management and administration is based on profiles assigned to defined users.

Thanks to [Sean Kavanagh](https://github.com/skavanagh) for designing and writing this excellent application.    The following documentation tells you how to use the `docker-keybox` image, a lean full-featured Docker image that has the following features:

* Lean 240MB image (compared to some other KeyBox images that are 600-800MB).
* Works both as a self-contained image, or will automatically recognize attached storage devices so that persistent KeyBox data is not stored in the container.  Makes it easy to upgrade when new images are released.
*  Fully configurable using environment variables, including options for logging, and all configurable Keybox options.  A fully customized container can be started without the need to build a new image.
* Automatically generates a self-signed SSL certificate matched to your domain, or allows you to easily add your own legitimate SSL certificate.

##Quick Start

You can get started quickly using the image hosted on Docker Hub.  For example, to quickly create a running self-contained KeyBox server daemon:

    $ docker pull garywiz/docker-keybox
    $ docker run -d -p 8443:8443 garywiz/docker-keybox

Within a few seconds, you should be able to use KeyBox by going to `https://localhost:8443/`.    The default login user is `admin` with a password of `changeme`.

If you want to store persistent KeyBox data locally outside the image, you can use the built-in launcher script.   Extract the launcher script from the image like this:

    $ docker run -i --rm garywiz/docker-keybox --task get-launcher | sh

This will create a flexible launcher script that you can customize or use as a template.  You can run it as a daemon:

    $ ./run-docker-keybox.sh -d

Or, if you want to have local persistent storage:

    $ mkdir docker-keybox-storage
    $ ./run-docker-keybox.sh -d

Now, all persistent data will be stored in the `docker-keybox-storage` directory.  The container itself is therefore entirely disposable.

The `run-docker-keybox.sh` script is designed to be self-documenting and you can edit it to change start-up options and storage options.  You can get up-to-date help on the image's features like this:

    $ docker run -i --rm garywiz/docker-keybox --task get-help

##Full Option List

If you want to invent your own start-up, or are using an orchestration tool, here is a quick view of all the configuration options piled into one command along with their defaults:

    $ docker run -d garywiz/docker-keybox \
      -p 8443:8443 \
      -e CONFIG_LOGGING=stdout \
      -e CONFIG_AUTHKEYS_REFRESH=120 \
      -e CONFIG_ENABLE_KEY_MANAGEMENT=true \
      -e CONFIG_ENABLE_OTP=true \
      -e CONFIG_ENABLE_AUDIT=false \
      -e CONFIG_DELETE_AUDIT_AFTER=90 \
      -e CONFIG_FORCE_KEY_GENERATION=true \
      -e CONFIG_EXT_SSL_HOSTNAME=localhost

* **`CONFIG_LOGGING`**: Either `stdout` (the default), `file`, or `syslog:host` (see "Logging Configuration" below).
* **`CONFIG_AUTHKEYS_REFRESH`**: If key management is enabled, this is the number of seconds that `authorized_keys` files on remote hosts will be refreshed.
* **`CONFIG_ENABLE_KEY_MANAGEMENT`**: If 'true', then remote servers will be managed and keys will be pushed to `authorized_keys` files.  If 'false', then this is just a bastion host for terminal access.
* **`CONFIG_ENABLE_OTP`**: If 'true', then two-factor authentication will be enabled.
* **`CONFIG_ENABLE_AUDIT`**: If 'true', then auditing will be enabled.  Defaults to 'false'.
* **`CONFIG_DELETE_AUDIT_AFTER`**: Set to the number of days audit logs will be kept.  Defaults to 90.
* **`CONFIG_FORCE_KEY_GENERATION`**: If 'true', then user keys will be generated and private keys will be downloaded automatically.  If 'false', then no key generation will occur and users can paste-in their own public keys.
* **`CONFIG_EXT_SSL_HOSTNAME`**: This is the name of the SSL host.  It should match the actual hostname people will use to access the server.  If set to "blank", then KeyBox will run using standard HTTP.

##Configuring Attached Storage

When configuring attached storage, there are two considerations:

1.  Attached storage must be mounted at `/apps/var` inside the container, whether using the Docker `-v` switch, or `--volumes-from`.
2. You will need to tell the container to match the user credentials using the `--create-user` switch ([documented here on the Chaperone site](http://garywiz.github.io/chaperone/ref/command-line.html#option-create-user)).

Both are pretty easy.  For example, assume you are going to store persistent data on your local drive in `/persist/keybox`.   Providing the directory exists, you can just do this:

    $ docker run -d -v /persist/keybox:/apps/var garywiz/docker-keybox \
         --create-user anyuser:/apps/var

When the container starts, it will assure that all internal services run as a new user called `anyuser` whose UID/GID credentials match the credentials your host box has assigned to `/persist/keybox`.

That's it!

When you run the container, you'll see that all the KeyBox persistent data files have been properly created in `/persist/keybox`.

##Logging Configuration

By default, all container logs will be sent to `stdout` and can be viewed using the `docker logs` command.

If this isn't suitable, there are two additional options that can be specified using the `CONFIG_LOGGING` environment variable:

**`CONFIG_LOGGING="file"`** - This setting will cause all logging information to be sent to `var/log/syslog.log` either inside the container or on attached storage.

**`CONFIG_LOGGING="syslog:hostname"`** - In this case, you need to specify `hostname` as the destination for logging.  The specified host must have a syslog-compatible daemon running on UDP port 514.

##Using Your Own SSL Keys

By default, a self-signed SSL key will be generated automatically for you at start-up.  If attached storage is used, the key will be generated only once.  Otherwise, a new key will be created each time a new container starts.

Most enterprise and production installations will often want to use their own pre-defined key.  In order to do so, you'll need to:

1.  Run this image using attached storage.  This is where you will store your keys, and they will persist when you upgrade the container.
2. Have your certificate and private key files in standard `PEM` format (the one usually used by Certificate authorities), or convert it from PKCS12 format as described below.
3. Not be an SSL noob.  I hate to say it, but it really helps if you've done this before.

Here is a step-by-step guide.

####Run with Persistent Storage

This is easy if you're using the provided launcher, as described above.  The first thing to do is run the container once just to initialize the persistent storage directory:

    $ mkdir docker-keybox-storage
	$ ./run-docker-keybox.sh -d
    Using attached storage at .../docker-keybox-storage
    00e9615bc51d63f9a150186482b3258d1c24b4f21ca0c781ae6e1717d9c97abc
    $

Now that your container is running, you should see the following in `docker-keybox-storage`:

    $ cd docker-keybox-storage
    $ ls
    certs config keydb log run
    $

Certificates are stored in the `certs` directory:

    $ cd certs
    $ ls
    jetty.keystore  ssl-cert-localhost.crt  ssl-cert-localhost.key
    $

The self-signed certificates is the file ending with `.crt` and the private key is the one ending with `.key`.

Once you see that these are present, it's probably a good idea to stop (and even delete) your container, as all persistent data is now stored in `docker-keybox-storage`.

####Replace the keys with your own

Note that the names of the certificate and keys will always look like this: `ssl-cert-<hostname>.crt`, where `<hostname>` will be the exact string you used with the `CONFIG_EXT_SSL_HOSTNAME` environment variable. 

So, if your site is going to be `https://keybox.example.com`, then make sure you edit your start-up scripts to change the hostname, then make sure your certificate and key files are correctly named as follows:

    ssl-cert-keybox.example.com.crt
    ssl-cert-keybox.example.com.key

If your keys are not already in `PEM` format, you may need to convert them using SSL as [this StackOverflow answer describes for PKCS12 keys](http://stackoverflow.com/questions/15144046/need-help-converting-p12-certificate-into-pem-using-openssl).

**IMPORTANT**: You will also need to delete the `jetty.keystore` file in the same directory.   This will cause the container start-up scripts to recognize your new key and rebuild the Jetty keystore file for you automatically.

####Re-run the container

Once you've replaced the certificates, you can simply restart the old container, or create a new container using the same attached storage location.  Your new certificate will then be in use.
