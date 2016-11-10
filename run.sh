#!/bin/sh
set -e

ARGS="-config=/etc/consul-template.d"
ARGS="${ARGS} -log-level=${CONSUL_TEMPLATE_LOG_LEVEL:-err}"
ARGS="${ARGS} -exec-kill-signal=SIGQUIT"
ARGS="${ARGS} -exec-kill-timeout=${CONSUL_TEMPLATE_EXEC_KILL_TIMEOUT:-30s}"
ARGS="${ARGS} -exec-reload-signal=SIGHUP"
ARGS="${ARGS} -exec-splay=${CONSUL_TEMPLATE_EXEC_SPLAY:-5s}"
ARGS="${ARGS} -template=/etc/nginx/nginx.conf.ctmpl:/etc/nginx/nginx.conf"

for tmpl in /etc/nginx/templates/*; do
  if [ ! -f "$tmpl" ]; then break; fi
  ARGS="${ARGS} -template=${tmpl}:/etc/nginx/rendered/$(basename $tmpl .ctmpl)"
done

# Test the nginx config
if [ "$1" = "-t" ]; then
  shift
  exec consul-template -exec="/usr/sbin/nginx -t" $ARGS "$@" || exit 1
fi

exec consul-template -exec="/usr/sbin/nginx" $ARGS "$@"
