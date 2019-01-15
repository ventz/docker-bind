### ISC BIND9 Container (Stable: 9.12.3_xx) built on top of Alpine
### Last update: 1-15-19
### Latest Stable Docker Tag: 9.12.3_r0

NOTE: "Last Update" is the date of the latest DockerHub build.

This container is a super small (~5MB compressed pull, and only ~9MB
when extracted) FULL version of ISC BIND9.

It is ideal for an extremely secure and fast master (authoritative server),
slave, recursive server/resolver, RPZ "dns firewall", or just
about any other purpose you can use bind for.

# Security - always on the latest stable BIND release!
This container will _always_ be up to date on the latest
stable+patched version, usually within 24 hours of it being available
in Alpine. In fact, most of the BIND vulnerabilities so far have been
reported by me to the Alpine developers.

# How to deploy a Bind (DNS) server?
This container contains everything needed in terms of configuration to
run as an authoritative server or a recursive resolver/forwarding cacher.

However, the default config permits queries and recursion only from 127.0.0.1 - which will not be too useful :)
But the assumption is that you will override ```/etc/bind``` with your configs, and ```/var/cache/bind``` with your zones.

# Required "DATA" directory - for configs and zone data:
This container assumes you have a "/DATA" folder with with your container specific data.
(You can change that folder, sub-folders, and file points as needed, but make sure you update the "-v" mounts for the run.)

Specifically, you need to have these directories/paths:
```
1.) [ *REQUIRED* ]
In your "/DATA/etc/bind" directory, a file "named.conf", which acts as an entry point to your configs
Take a look at the default config, and the example configs provided

2.) [ *REQUIRED* ]
A "/DATA/var/cache/bind" directory for all of the master or slave zones. If it's for slave zones, it will populate automatically and you can leave it blank.
```


# How to run a BIND ("named") Docker Container?

## Default Example:
This is just to test it out - by default only allows queries from
itself (127.0.0.1) -- pretty useless for real world usage
```
docker run --name=dns-test
-it -d \
--dns=8.8.8.8 --dns=8.8.4.4 \
-p 53:53/udp -p 53:53 \
ventz/bind
```

## Customer Override Example for Authoritative Master
Edit: named.conf.local with your forward zone at least
and create the file in /var/cache/bind/$yourdomain.tld
```
docker run --name=dns-master
-it -d \
--dns=8.8.8.8 --dns=8.8.4.4 \
-p 53:53/udp -p 53:53 \
-v /DATA/etc/bind:/etc/bind \
-v /DATA/var/cache/bind:/var/cache/bind \
ventz/bind
```

## Custom Override Example for Recursive Resolver/Cacher:
Edit: named.conf.options -> change the "allow-recursion" and  "allow-query" with your subnets
```
docker run --name=dns-resolver
-it -d \
--dns=8.8.8.8 --dns=8.8.4.4 \
-p 53:53/udp -p 53:53 \
-v /DATA/etc/bind:/etc/bind \
-v /DATA/var/cache/bind:/var/cache/bind \
ventz/bind
```

Additional options may be passed to the bind daemon via the `OPTIONS` argument, provided as:
`docker run --env OPTIONS='...'
