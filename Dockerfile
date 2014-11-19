# Docker container for running PHP/Apache Apps

FROM       d11wtq/apache:2.4.10
MAINTAINER Chris Corbyn <chris@w3style.co.uk>

RUN sudo apt-get update -qq -y
RUN sudo apt-get install -qq -y \
    libcurl4-openssl-dev        \
    libmysqlclient-dev          \
    libpq-dev                   \
    libvpx-dev                  \
    libjpeg-dev                 \
    libpng-dev

RUN cd /tmp;                                                      \
    curl -LO http://au1.php.net/distributions/php-5.5.14.tar.bz2; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                          \
    cd php-*;                                                     \
    ./configure                                                   \
      --prefix=/usr/local                                         \
      --with-config-file-path=/www                                \
      --with-config-file-scan-dir=/www/php.ini.d/                 \
      --with-apxs2=/usr/local/bin/apxs                            \
      --with-openssl                                              \
      --with-curl                                                 \
      --enable-pcntl                                              \
      --with-readline                                             \
      --enable-soap                                               \
      --enable-sockets                                            \
      --enable-zip                                                \
      --with-zlib                                                 \
      --with-bz2                                                  \
      --with-gettext                                              \
      --with-mhash                                                \
      --with-mysql                                                \
      --with-mysqli                                               \
      --with-pdo-mysql                                            \
      --with-pgsql                                                \
      --with-pdo-pgsql                                            \
      --enable-mbstring                                           \
      --with-xmlrpc                                               \
      --with-gd                                                   \
      ;                                                           \
    make && make install;                                         \
    cd; rm -rf /tmp/php-*

RUN sudo rm -f /www/htdocs/index.html

ADD www /www
