#!/bin/sh
OPTIONS=$@
chown -R root:named /etc/bind /var/run/named
chown -R named:named /var/cache/bind
chmod -R 770 /var/cache/bind /var/run/named
chmod -R 750 /etc/bind
# By default - run in foreground and log to STDERR (console)
# can be changed by running container with: -e "BIND_LOG=-f"
exec /usr/sbin/named -c /etc/bind/named.conf $BIND_LOG -u named $OPTIONS
