FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG USER=web
ARG UID=1000
ARG GID=1000

# Install system dependencies
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
      git \
      mariadb-client \
      openssh-client \
      jq \
      patch \
      curl \
      cron \
      nano \
      sendmail \
      sshpass \
      jpegoptim \
      optipng \
      pngquant \
      gifsicle \
      vim \
      zip \
      unzip \
      sudo \
      gnupg \
      awscli \
# install Nodejs
      nodejs \
      npm \
# Ghostscript is required for rendering PDF previews
      ghostscript \
    ; \
    rm -rf /var/lib/apt/lists/*

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN set -ex; savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        webp \
        imagemagick \
        libfreetype6-dev \
        libargon2-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        libjpeg-dev \
        libsqlite3-dev \
        libmagickwand-dev \
        libsodium-dev \
        libxslt1-dev \
        libwebp-dev \
        libpng-dev \
        libzip-dev \
        libonig-dev \
        libbz2-dev \
        libxml2-dev \
        libmcrypt-dev \
        libpng-dev \
        libssl-dev \
        libz-dev \
        zlib1g-dev \
        libcurl3-dev \
        libedit-dev \
        libpspell-dev \
        libpq-dev \
        libreadline-dev \
        unixodbc-dev \
    ; \
    \
    docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg; \
    docker-php-ext-install -j "$(nproc)" \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        mysqli \
        opcache \
        zip \
        soap \
        sockets \
        sodium \
        sysvmsg \
        sysvsem \
        sysvshm \
        pdo_mysql \
        pdo_pgsql \
        mbstring \
        pcntl \
        curl \
        simplexml \
        xml \
        xsl \
        session \
        intl \
    ; \
    \
# MCrypt
    pecl install mcrypt-1.0.5; \
    docker-php-ext-enable mcrypt; \
# Imagick
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    \
# Redis
    pecl install redis; \
    docker-php-ext-enable redis; \
    \
# XDebug
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    \
# Ioncube
    cd /tmp; \
    curl -O https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz; \
    tar zxvf ioncube_loaders_lin_x86-64.tar.gz; \
    export PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;"); \
    export PHP_EXT_DIR=$(php-config --extension-dir); \
    cp "./ioncube/ioncube_loader_lin_${PHP_VERSION}.so" "${PHP_EXT_DIR}/ioncube.so"; \
    rm -rf ./ioncube; \
    rm ioncube_loaders_lin_x86-64.tar.gz; \
    docker-php-ext-enable ioncube; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
                | awk '/=>/ { print $3 }' \
                | sort -u \
                | xargs -r dpkg-query -S \
                | cut -d: -f1 \
                | sort -u \
                | xargs -rt apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=2'; \
                echo 'opcache.fast_shutdown=1'; \
        } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
# Get latest Composer
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer --version=2.2.18; \
# Get n98-magerun2
    curl -O https://files.magerun.net/n98-magerun2.phar && \
    chmod +x ./n98-magerun2.phar && cp ./n98-magerun2.phar /usr/local/bin/n98-magerun2

# Create system user to run Composer and Artisan Commands
RUN groupadd -g ${GID} ${USER}; \
    useradd -g ${GID} -u ${UID} -ms /bin/bash ${USER}; \
    usermod -aG www-data ${USER}; \
    chown -R ${USER}:${USER} /var/www/html; \
    echo "${USER}      ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers; \
    \
# Add n98-magerun module check Vulnerability Database
    mkdir -p /home/${USER}/.n98-magerun2/modules && cd /home/${USER}/.n98-magerun2/modules; \
    git clone https://github.com/gwillem/magevulndb.git && chown -R ${USER}:${USER} /home/${USER}/.n98-magerun2; \
    \
# Fix /etc/hosts to handle the IP change
    cat /etc/hosts | grep -v "secomm.host.internal" > /etc/hosts; \
    echo "`/sbin/ip route|awk '/default/ { print $3 }' | grep -v ppp` secomm.host.internal" | tee -a /etc/hosts > /dev/null; \
    \
# Config www.conf
    echo 's/user = www-data/user = ${USER}/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/group = www-data/group = ${USER}/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/;listen.owner = www-data/listen.owner = ${USER}/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/;listen.group = www-data/listen.group = ${USER}/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/;listen.mode = 0660/listen.mode = 0660/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/pm =.*/pm = dynamic/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/pm.max_children =.*/pm.max_children = 5/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/pm.start_servers =.*/pm.start_servers = 2/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/pm.min_spare_servers =.*/pm.min_spare_servers = 1/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/pm.max_spare_servers =.*/pm.max_spare_servers = 3/g' /usr/local/etc/php-fpm.d/www.conf; \
    echo 's/;access.log = .*/access.log = \/proc\/self\/fd\/2/g' /usr/local/etc/php-fpm.d/www.conf; \
    \
# Fix link-count, as cron is being a pain, and docker is making hardlink count >0 (very high)
    touch /etc/crontab /etc/cron.*/*

# Copy existing application directory contents
# COPY ./config/www.conf /usr/local/etc/php-fpm.d/
COPY ./config/php.ini /usr/local/etc/php/
COPY ./config/php-fpm.conf /usr/local/etc/
COPY ./scripts/* /usr/local/bin/

# Change current user to www
USER ${UID}:${GID}

# Set working directory
WORKDIR /var/www/html

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm", "--nodaemonize"]