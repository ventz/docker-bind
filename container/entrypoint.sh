#!/bin/sh
OPTIONS=$@
# "Run Time" changes - needed for when creating a *new* directory/first-time volume map
# A great example of this is "/var/cache/bind" for dynamic configs, and mapping it in
# The first time around, it will not be owned by named:named, and thus it won't be writable
chown -R root:named /etc/bind /var/run/named
chown -R named:named /var/cache/bind
chmod 770 /var/cache/bind /var/run/named
chmod -R 750 /etc/bind
# By default - run in foreground and log to STDERR (console)
# can be changed by running container with: -e "BIND_LOG=-f"
exec /usr/sbin/named -c /etc/bind/named.conf $BIND_LOG -u named $OPTIONS
