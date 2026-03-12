#!/bin/bash
echo "NGINX_PORT: $NGINX_PORT"

sed -i "s/__REPLACE_PORT__/$NGINX_PORT/g" /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"