## Forked from [ventz/docker-bind](https://github.com/ventz/docker-bind)

### ISC BIND9 Container (Stable: 9.11.1_xx) built on top of Alpine
### Last update: 9-18-17

NOTE: "Last Update" is the date of the latest DockerHub build.

This container is a super small (~5MB compressed pull, and only ~9MB
when extracted) FULL version of ISC BIND9.

It is ideal for a quick master, slave, recursive server/resolver, RPZ
"dns firewall", or just about any other purpose you can use bind for.

# Security - always on the latest stable release!
This container will _always_ be up to date on the latest
stable+patched version, usually within 24 hours of it being available
in Alpine. In fact, most of the BIND vulnerabilities so far have been
reported by me to the Alpine developers.

# Required "DATA" directory - for named.conf and zone data:
This container assumes you have a "/DATA" folder with with your container specific data.
You can change that folder (and sub-folders) as needed, but make sure you update the "-v" mounts for the run.

Specifically, you need to have these directories/paths:
```
1.) [ *REQUIRED* ]
In your "/DATA/etc/bind" directory, a file "named.conf", which acts as an entry point to your configs

2.) [ *REQUIRED* ]
A "/DATA/var/named" directory for all of the master or slave zones. If it's for slave zones, it will populate automatically and you can leave it blank.

3.) [ *OPTIONAL* ]
A "/DATA/var/log/named" directory for logging your DNS requests/returns/other breakdown. By default, logging is done to the console
```


# How to run a BIND ("named") Docker Container?

```
docker run --name=dns-master01
-it -d \
--dns=8.8.8.8 --dns=8.8.4.4 \
-p 53:53/udp -p 53:53 \
-v /DATA/etc/bind:/etc/bind \
-v /DATA/var/cache/bind:/var/named \
-v /DATA/var/log/named:/var/log/named \
unifio/bind
```
