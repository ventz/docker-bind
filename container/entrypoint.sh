#!/bin/sh

# Generate rndc.key file
rndc-confgen -a -b 512 -u named -r /dev/urandom -c /var/run/named/rndc.key

# Update bind.keys file
(
    cd /dev/shm
    curl -JLRO 'https://ftp.isc.org/isc/bind9/keys/9.11/bind.keys.v9_11{,.sha512.asc}'
    curl 'https://www.isc.org/downloads/software-support-policy/openpgp-key/' | sed -e 's/-----BEGIN/\n&/' | gpg --import
    trap "rm -f bind.keys*" EXIT
    gpg --verify bind.keys.v9_11.sha512.asc bind.keys.v9_11 || exit $?
    cmp -s bind.keys.v9_11 /var/bind/bind.keys && exit 0
    cp -p /var/bind/bind.keys . && \
        cp bind.keys.v9_11 bind.keys && \
        mv -v bind.keys /var/bind/bind.keys
) >/dev/null 2>&1

# Ensure bind.keys file
test -s /etc/bind/bind.keys || cp -p /var/bind/bind.keys /etc/bind/

# Fix up permissions on mounts
chgrp -R named /etc/bind /var/cache/bind

chmod -R g+r /etc/bind
chown root:named /etc/bind
chmod 0750 /etc/bind

chmod -R g+rw /var/cache/bind
chown named:named /var/cache/bind
chmod 0770 /var/cache/bind

# Check for configuration errors before running named
named-checkconf -z /etc/bind/named.conf || exit $?

# Run in foreground and log to STDERR (console):
exec /usr/sbin/named -c /etc/bind/named.conf -g -u named
