#!/usr/bin/dumb-init /bin/sh

export NGINX_CONF_KEY=${NGINX_CONF_KEY-nginx}

ARGS="-config=/etc/consul-template.d"
ARGS="${ARGS} -template=/etc/nginx/nginx.conf.ctmpl:/etc/nginx/nginx.conf"

for tmpl in /etc/nginx/templates/*; do
  if [ ! -f "$tmpl" ]; then break; fi
  ARGS="${ARGS} -template=${tmpl}:/etc/nginx/rendered/$(basename $tmpl .ctmpl)"
done

if [ "$1" = "consul-template" ]; then
  shift
  exec consul-template $ARGS "$@"
fi

if [ "$1" = "config-test" ]; then
  shift
  consul-template -exec="/usr/sbin/nginx -t" $ARGS "$@" || exit 1
fi

exec "$@"
