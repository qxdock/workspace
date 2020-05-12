FROM phusion/baseimage:latest

MAINTAINER takashiki <857995137@qq.com>

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND=noninteractive
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM=xterm

# php ppa
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

RUN apt-get update -yqq && \
    apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php7.4-cli \
        php7.4-common \
        php7.4-curl \
        php7.4-intl \
        php7.4-json \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-pgsql \
        php7.4-sqlite \
        php7.4-sqlite3 \
        php7.4-zip \
        php7.4-bcmath \
        php7.4-memcached \
        php7.4-gd \
        php7.4-dev \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        zsh \
        postgresql-client && \
    pecl channel-update pecl.php.net

RUN apt-get -y install libxml2-dev php7.4-soap \
    libldap2-dev php7.4-ldap \
    php7.4-imap

RUN pecl install -o -f redis && \
    echo "extension=redis.so" >> /etc/php/7.4/mods-available/redis.ini && \
    phpenmod redis
    
RUN pecl install swoole && \
    echo "extension=swoole.so" >> /etc/php/7.4/mods-available/swoole.ini && \
    ln -s /etc/php/7.4/mods-available/swoole.ini /etc/php/7.4/cli/conf.d/20-swoole.ini

USER root

# composer
RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer global require hirak/prestissimo && \
    composer global require slince/composer-registry-manager && \
    echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc && \
    . ~/.bashrc

RUN apt-get install -y software-properties-common gnupg && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    npm i -g nrm n npm gulp webpack cross-env yarn && \
    n latest

# clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www
