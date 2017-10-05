#!/bin/bash
# NOTE: Please make sure you have /DATA with those directories as sources
#       and the appropriate named.conf + zone files

docker run --name=dns-master01
-it -d \
--dns=8.8.8.8 --dns=8.8.4.4 \
-p 53:53/udp -p 53:53 \
-v /DATA/etc/bind:/etc/bind \
-v /DATA/var/named:/var/named \
-v /DATA/var/log:/var/log/named \
ventz/bind
