NOTE: Example assumes you have a "/dns" with your container specific data!
Change as needed with the SRC data that you are mounting into the container.
Example named data is defined in the example subdir.

## Required "DATA" directory - named.conf and zone data:
This container assumes you have a "/dns" folder with your container specific data:
You can change that folder as needed, but make sure you update the "-v" mounts for run time

1.) [ *REQUIRED* ] In your /dns/etc/bind a file "named.conf", which acts as an entry point to your configs

2.) [ *REQUIRED* ] A "/dns/var/cache/bind" directory for all of the master or slave zones. If it's for slave zones, it will populate automatically and you can leave it blank.

3.) [ *OPTIONAL* ] "/dns/var/log/named" directory for logging your DNS requests/returns/other breakdown.

4.) [ *OPTIONAL* ] set environment variable "UDPLOGHOST" or "TCPLOGHOST", if defined rsyslog will be started with remote SYSLOG logging to these hosts. If you use remote syslog, then it might be useful to set the hostname of the container depending on your server syslog configuration (the logs on the syslog server might get stored based on the hostname of the client)


## Run BIND Container without log dir and with remote syslog logging, and example DNS config files:
```
cd docker-bind # Go to into Git Repo
SRC=`pwd`/example
docker run --name=dnsserver --hostname=dnsserver --dns=8.8.8.8 --dns=8.8.4.4 -p 53:53/udp -p 53:53 -e UDPLOGHOST=192.168.0.17 -v $SRC/etc/bind:/etc/bind:ro -v $SRC/var/cache/bind:/var/cache/bind qindel/bind-syslog
```

## Run BIND Container:
```
docker run --name=dnsserver --hostname=dnsserver --dns=8.8.8.8 --dns=8.8.4.4 -p 53:53/udp -p 53:53 -v /dns/etc/bind:/etc/bind:ro -v /dns/var/cache/bind:/var/cache/bind -v /dns/var/log/named:/var/log/named qindel/bind-syslog
```

## Run BIND Container without log dir and with remote syslog logging:
```
docker run --name=dnsserver --hostname=dnsserver --dns=8.8.8.8 --dns=8.8.4.4 -p 53:53/udp -p 53:53 -e UDPLOGHOST=192.168.0.17 -v /dns/etc/bind:/etc/bind:ro -v /dns/var/cache/bind:/var/cache/bind qindel/bind-syslog
```
