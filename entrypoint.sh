#!/bin/sh
chown -R named:named /var/cache/bind
/usr/sbin/named -c /etc/bind/named.conf -g -u named
