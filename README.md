### ISC BIND9 Container (Stable: 9.14.8_xx) built on top of Alpine
### Last update: 2-6-20
### Latest Stable Docker Tag: 9.14.8-r5

NOTE: "Last Update" is the date of the latest DockerHub build.

This container is a super small (~5MB compressed pull, and only ~9MB
when extracted) FULL version of ISC BIND9.

It is ideal for an extremely secure and fast master (authoritative server),
slave, recursive server/resolver, RPZ "dns firewall", or just
about any other purpose you can use bind for.

To get started quickly, skip to step "D".

# (A.) Security - always on the latest stable BIND release!
This container will _always_ be up to date on the latest
stable+patched version, usually within 24 hours of it being available
in Alpine. In fact, most of the BIND vulnerabilities so far have been
reported by me to the Alpine developers.

# (B.) How to deploy a Bind (DNS) server?
This container contains everything needed in terms of configuration to
run as an authoritative server or a recursive resolver/forwarding cacher.

However, the default config permits queries and recursion only from 127.0.0.1 - which will not be too useful :)
But the assumption is that you will override ```/etc/bind``` with your configs, and ```/var/cache/bind``` with your zones.

# (C.) Required "DATA" directory - for configs and zone data:
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


# (D.) How to run a BIND ("named") Docker Container?

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

# (E.) FAQs

## How do I generate an RNDC Key?
```
docker run -it --rm --entrypoint "/usr/sbin/rndc-confgen" ventz/bind
```

Take the portion that looks like this and save to "/etc/bind/rndc.key":
```
# Start of rndc.conf
key "rndc-key" {
    algorithm hmac-sha256;
    # Note: the secret will be different, this is just an example
    secret "zjVC59ehGxbbB6OhYhGaqUTIXu8Imcg3VKzvoMwIMzY=";
};
```

## What configuration files do I need to get started?

I highly recommend reading more about bind if this is your question. Here are some useful resources:

* https://www.bind9.net/manuals
* https://wiki.debian.org/Bind9
* https://help.ubuntu.com/community/BIND9ServerHowto
* https://www.zytrax.com/books/dns/ch7/
* https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-18-04

That said, as a bare minimum (and depending on what you want - recursive, authoritative, etc), you need:

[note: all of these are provided in `container/configs` folder]

1.) Main config: `/etc/bind/named.conf`

2.) Options: `/etc/bind/named.conf.options` (note: sane and secure defaults for recursive! If for authoritative, turn off recursive at least!)

3.) Local zones: `/etc/bind/named.conf.local` (for your zone configs if authoritative/slave/etc)

4.) Optional: `/etc/bind/named.conf.rfc1918` (for your RFC1918 "private IP" zone definitions - this is optional, and while recommended, you may comment out the last line in `named.conf.local` that utilizes it)

5.) Optional: `/etc/bind/default-zones` (folder for rfc1918 definitions - not needed if `named.conf.rfc1918` is not used)

## How do I log everything:

1.) Add to your `named.conf`:
```
...
include "/etc/bind/named.conf.logging";
...
```

and

2.) Create a file `named.conf.logging` with:
```
logging {
    channel stdout {
        stderr;
        severity info;
        print-category no;
        print-severity no;
        print-time yes;
    };
	# Customize categories as needed
    # To log everything, keep at least "default"
    category security { stdout; };
    category queries  { stdout; };
    category dnssec   { stdout; };
    category xfer-in  { stdout; };
    category xfer-out { stdout; };
    category default  { stdout; };
};

For more information, see: https://www.slideshare.net/MenandMice/bind-9-logging-best-practices

## How do I just change Bind STDERR to STDOUT logging?

There is now a "BIND_LOG" ENV (environment) variable for logging

Environment variables can both have a default and be customized at run time. 

```
"-g" = (default) Run the server in the foreground and force all logging stderr.
"-f" = Run the server in the foreground
```

By default, the "-g" value is set, as that logs all to STDERR.
You can now override it with "-f" by passing `-e "BIND_LOG=-f"` to `docker run`


