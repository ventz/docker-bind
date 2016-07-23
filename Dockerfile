FROM alpine:latest
EXPOSE 53

ENV UDPLOGHOST=
ENV TCPLOGHOST=
# The rsyslog package for alpine has no omrelp support
#ENV RELPLOGHOST=

RUN apk --update add bind
RUN apk --update add rsyslog

RUN mkdir -m 0755 -p /var/spool/rsyslog &&  addgroup syslog && adduser -D -s /sbin/nologin -h /var/spool/rsyslog -G syslog syslog && chown -R syslog:syslog /var/spool/rsyslog 
RUN mkdir -m 0755 -p /var/run/named && chown -R root:named /var/run/named

# /var/cache/bind needs to be owned by "bind"
# since we are mounting, do it manually
# NOTE: Per Dockerfile manual --> need to mkdir the mounted dir to chown
RUN mkdir -m 0755 -p /var/cache/bind && touch /var/cache/bind/docker-init && chown -R named:named /var/cache/bind

# Mounts
# NOTE: Per Dockerfile manual -->
#	"if any build steps change the data within the volume
# 	 after it has been declared, those changes will be discarded."
VOLUME ["/var/spool/rsyslog"]
VOLUME ["/etc/rsyslog"]
VOLUME ["/etc/bind"]
VOLUME ["/var/cache/bind"]

COPY entrypoint.sh /
COPY rsyslog.conf /etc/rsyslog.conf
ENTRYPOINT ["/entrypoint.sh"]
