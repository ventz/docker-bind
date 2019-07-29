#!/bin/sh
OPTIONS=$@
chown -R root:named /etc/bind /var/run/named
chown -R named:named /var/cache/bind
chmod -R 770 /var/cache/bind /var/run/named
chmod -R 750 /etc/bind
# Run in foreground and log to STDERR (console):
exec /usr/sbin/named -c /etc/bind/named.conf -g -u named $OPTIONS
