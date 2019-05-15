FROM carlosocarvalho/php73-fpm:dev
#carlosocarvalho/php73-fpm:latest

WORKDIR "/application"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

COPY ./start /usr/local/bin/start

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y install git \
    && apt-get -y --no-install-recommends install  php-memcached php7.3-mysql php7.3-mongodb php7.3-pgsql php-redis php-xdebug php7.3-gd php-imagick php7.3-ldap php-mongodb php7.3-xsl php-yaml php-zmq \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN chmod u+x /usr/local/bin/start
