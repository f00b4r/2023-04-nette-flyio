#!/usr/bin/env bash
set -e

make setup

/usr/sbin/php-fpm8.2 -F -R -y /etc/php/8.2/php-fpm.conf &
caddy run --config /etc/Caddyfile &
wait -n
