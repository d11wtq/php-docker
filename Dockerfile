# Docker container for running PHP/Apache Apps

FROM       d11wtq/ubuntu
MAINTAINER Chris Corbyn <chris@w3style.co.uk>

RUN sudo apt-get install -qq -y \
    sendmail-base               \
    libapr1-dev                 \
    libaprutil1-dev             \
    libcurl4-openssl-dev

RUN cd /tmp;                                                             \
    curl -LO http://apache.mirror.uber.com.au/httpd/httpd-2.4.9.tar.bz2; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                                 \
    cd httpd-*;                                                          \
    ./configure                                                          \
      --prefix=/usr/local                                                \
      --with-config-file-path=/www                                       \
      --enable-so                                                        \
      --enable-cgi                                                       \
      --enable-info                                                      \
      --enable-rewrite                                                   \
      --enable-deflate                                                   \
      --enable-ssl                                                       \
      --enable-mime-magic                                                \
      ;                                                                  \
    make && make install;                                                \
    cd; rm -rf /tmp/httpd-*

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
      --enable-mbstring                                           \
      ;                                                           \
    make && make install;                                         \
    cd; rm -rf /tmp/php-*

ADD www /www

EXPOSE 8080

CMD [ "apachectl",             \
      "-d", "/usr/local",      \
      "-f", "/www/httpd.conf", \
      "-DFOREGROUND" ]
