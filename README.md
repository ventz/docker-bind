NOTE: Example assumes you have a "/dns-slave01" with your container specific data!
Change as needed with the SRC data that you are mounting into the container.

## Required "DATA" directory - named.conf and zone data:
This container assumes you have a "/dns" folder with your container specific data:
You can change that folder as needed, but make sure you update the "-v" mounts for run time

1.) [ *REQUIRED* ] In your /dns/etc/bind a file "named.conf", which acts as an entry point to your configs

2.) [ *REQUIRED* ] A "/dns/var/cache/bind" directory for all of the master or slave zones. If it's for slave zones, it will populate automatically and you can leave it blank.

3.) [ *OPTIONAL* ] "/dns/var/log/named" directory for logging your DNS requests/returns/other breakdown.

## Run BIND Container:
```
docker run --name=dns-slave01 -d --dns=8.8.8.8 --dns=8.8.4.4 \
-p 53:53/udp -p 53:53 \
-v /dns-slave01/etc/bind:/etc/bind \
-v /dns-slave01/var/cache/bind:/var/cache/bind \
-v /dns-slave01/var/log/named:/var/log/named \
ventz/bind
```
