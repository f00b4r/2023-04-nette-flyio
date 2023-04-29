FROM composer:2 as php

WORKDIR /srv

COPY ./composer.json /srv/
COPY ./composer.lock /srv/

RUN composer install

FROM debian:bullseye-slim

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	# dependencies
	apt-get install -y wget curl apt-transport-https ca-certificates unzip tini && \
	wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
	echo "deb https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/php.list && \
	echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" > /etc/apt/sources.list.d/caddy-fury.list && \
	apt-get update && apt-get install -y \
		curl \
		make \
		git \
		caddy \
		php8.2-cli \
		php8.2-fpm \
		php8.2-intl \
		php8.2-mbstring \
		php8.2-sqlite3 \
		php8.2-tokenizer \
		php8.2-xml \
		php8.2-zip && \
	# composer
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	# cleanup
	apt-get remove -y wget && \
	apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

COPY .docker/Caddyfile /etc/Caddyfile
COPY .docker/php.ini /etc/php/8.2/conf.d/999-php.ini
COPY .docker/php-fpm.conf /etc/php/8.2/php-fpm.conf
COPY .docker/entrypoint.sh /entrypoint.sh
COPY --from=php /srv/vendor /srv/vendor
COPY . /srv

WORKDIR /srv

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
