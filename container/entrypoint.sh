#!/bin/sh
if [ -d /var/named ]; then
  chown -R named:named /var/named
fi
if [ -e /etc/bind/named.conf ]; then
  chown root:named /etc/bind/named.conf
  if [ -d  /var/log/named ]; then
    chown -R named:named /var/log/named
  fi
  # Run in foreground and log to STDERR (console):
  /usr/sbin/named -c /etc/bind/named.conf -g -u named
else
  echo "Required files and directories not present."
  exit 1
fi

