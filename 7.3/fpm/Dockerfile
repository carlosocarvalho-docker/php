FROM carlosocarvalho/php73-cli:1.0.3

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install php7.3-fpm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# PHP-FPM packages need a nudge to make them docker-friendly
COPY overrides.conf /etc/php/7.3/fpm/pool.d/z-overrides.conf

# PHP-FPM has really dirty logs, certainly not good for dockerising
# The following startup script contains some magic to clean these up
COPY fpm-startup /usr/bin/php-fpm

RUN chmod u+x /usr/bin/php-fpm

CMD /usr/bin/php-fpm

# Open up fcgi port
EXPOSE 9000
