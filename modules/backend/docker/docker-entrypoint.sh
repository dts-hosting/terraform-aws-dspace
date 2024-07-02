#!/usr/bin/env sh
set -eu

envsubst '${PROXY_HOST}' \
  < /etc/nginx/conf.d/single-domain.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"