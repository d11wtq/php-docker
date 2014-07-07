# PHP + Apache Docker Container

**WORK IN PROGRESS, DO NOT USE**

This is a docker container for running PHP 5 applications under Apache 2. It is
designed to be very minimal, but in such a way that extending it is easy.
Apache listens on port 8080 inside the container and runs in the foreground
under a non-privileged user.

## Usage

Apache is run in the foreground with a minimal config that can be found at in
the [www/](https://github.com/d11wtq/php-docker/blob/master/www) directory of
the GitHub repository for this container.

### Configuration

The document root is set to /www/htdocs and you are expected to mount this
directory as a volume, or add it to container, using this as the base image.

Extending the basic Apache 2 configuration (which is intentionally very
minimal) can be done by adding \*.conf files to /www/httpd.conf.d/, again
either by mounting a volume, or by using this image as a base image.

Extending the PHP configuration can be done by adding \*.ini files to
/www/php.ini.d/ via the same means. The default configuration is both minimal
and strict.

### Web Access

Here's an example of serving a WordPress blog with mod_auth_user loaded,  using
shared volumes.

```
# Start MySQL somewhere
docker run -d  \
  --name mysql \
  your-mysql-container

# Start Wordpress, linking to MySQL
docker run -d                          \
  --name wordpress                     \
  -p 8080:8080                         \
  --link mysql:mysql                   \
  -v /path/to/wordpress:/www/htdocs    \
  -v /path/to/conf.d:/www/httpd.conf.d \
  d11wtq/php
```

The contents of /path/to/wordpress/ would be the directory including the
index.php from WordPress. The contents of /path/to/conf.d/ would be a file
named mod_auth_user.conf, with the contents:

``` apache
LoadModule auth_user_module modules/mod_auth_user.so
```

Now accessing http://localhost:8080/, you should see your WordPress blog.

You should be able to provide most needed configuration using this layout.

### Command Line Access

If you need to run PHP on the command line, just start /bin/bash in the
container:

```
docker run -ti d11wtq/php /bin/bash
```
