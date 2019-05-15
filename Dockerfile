
FROM ubuntu:bionic

ENV TERM=linux
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg \
    && apt-get install -y tzdata \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get -y --no-install-recommends install \
        software-properties-common \ 
        ca-certificates \ 
        curl \
        unzip 
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install msodbcsql17 -y \
    && apt-get -y install unixodbc-dev \
    && apt-get update
RUN add-apt-repository ppa:ondrej/php -y \
     && apt-get update \
     && apt-get -y install \  
        php7.3 \
        php7.3-dev \
        php7.3-xml \
        php7.3-curl \
        php7.3-json \
        php7.3-mbstring \
        php7.3-opcache \
        php7.3-readline \
        php7.3-xml \
        --allow-unauthenticated \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
    && echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini

