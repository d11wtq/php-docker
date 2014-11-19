# PHP + Apache Docker Container

> In the same manner is LAMP, MAMP and WAMP, I should have called this DAMP.

This is a docker container for running PHP 5 applications under Apache 2. It is
designed to be very minimal, but in such a way that extending it is easy.
Apache listens on port 8080 inside the container and runs in the foreground
under a non-privileged user.

All the 'standard' PHP extensions are compiled, which basically means you can
use MySQL, PgSQL, SQLite3, GD etc without doing anything special.

## Usage

Apache is run in the foreground with a minimal config that can be found at in
the [www/](https://github.com/d11wtq/apache-docker/blob/master/www) directory
of the GitHub repository for the Apache image on which this is based.

### Testing

Without any special configuration, the index page will serve up the `phpinfo()`
output. This should demonstrate that the container is working correctly.

```
docker run -p 8080:8080 d11wtq/php
```

Accessing http://localhost:8080/ should show the PHP Info page and Apache logs
should be written to stdout.

### Defaults

> **WARNING** `sendmail_path` is set to /bin/true, effectively disabling
> the `mail()` function. Pull requests welcomed that provide a light wrapper
> to send mail directly to the MX, without depending on a daemon.

I have made no attempts to create an exhaustive configuration for PHP and
Apache, rather focusing on setting a handful of minimal and sensible defaults
and ensuring it is easy to override these defaults. In summary, the defaults
are:

  * error_reporting E_ALL
  * display_errors On
  * short_open_tag Off
  * default_charset 'UTF-8'
  * date.timezone 'UTC'
  * memory_limit 128M
  * post_max_size 32M
  * upload_max_filesize 8M

For the Apache default, refer to
[d11wtq/apache-docker](https://github.com/d11wtq/apache-docker).

### Configuration

#### Apache

See: [d11wtq/apache-docker](https://github.com/d11wtq/apache-docker).

The document root is set to /www/htdocs/ and you are expected to mount this
directory as a volume, or add it to the container, using this image as the base
image.

#### PHP

> **NOTE**: The libphp5.so and associated config are loaded from an
> httpd.conf.d/ file that extends the base Apache configuration.

The main php.ini file resides in /www/php.ini, though it is kept to a minimum.

Extending the PHP configuration can be done by adding \*.ini files to
/www/php.ini.d/ using a volume, or by using this image as a base image. The
default configuration is both minimal and strict.

If you know what you're doing, feel free to mount the entire /www/ directory
as a volume and disregard the above, but make sure it contains at least an
httpd.conf. Both Apache and PHP have been installed with `--prefix=/usr/local`.

### Web Access

Here's an example of serving a WordPress blog with mod_rewrite loaded, using
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
named mod_rewrite.conf, with the contents:

``` apache
DirectoryIndex index.html index.php
AddType        application/x-httpd-php .php

LoadModule php5_module    modules/libphp5.so
LoadModule rewrite_module modules/mod_rewrite.so
```

Now accessing http://localhost:8080/, you should see your WordPress blog,
assuming it accesses MySQL on the hostname 'mysql'.

Here's the same example using a Dockerfile to create a new image, using this
image as the base image:

``` docker
FROM       d11wtq/php:latest
MAINTAINER Your Name

ADD /path/to/wordpress /www/htdocs
ADD /path/to/conf.d    /www/httpd.conf.d
```

Now build the new image:

```
docker build --rm -t your-wordpress .
```

And run it with:

```
# Start MySQL somewhere
docker run -d  \
  --name mysql \
  your-mysql-container

# Start Wordpress, linking to MySQL
docker run -d        \
  --name wordpress   \
  -p 8080:8080       \
  --link mysql:mysql \
  your-wordpress
```

You should be able to provide most needed configuration using this layout.

### Command Line Access

If you need to run PHP on the command line, just start /bin/bash in the
container:

```
docker run -ti d11wtq/php /bin/bash
```

By default the same configuration file is used for the CLI as for Apache.
