FROM alpine:latest
RUN apk --update add bind

RUN mkdir -m 0755 -p /var/run/named && chown root:named /var/run/named

# /var/cache/bind needs to be owned by "bind"
# since we are mounting, do it manually
# NOTE: Per Dockerfile manual --> need to mkdir the mounted dir to chown
RUN mkdir /var/cache/bind
RUN chown named:named /var/cache/bind
RUN chmod -R 0775 /var/cache/bind

# Mounts
# NOTE: Per Dockerfile manual -->
#	"if any build steps change the data within the volume
# 	 after it has been declared, those changes will be discarded."
VOLUME ["/etc/bind"]
VOLUME ["/var/cache/bind"]

EXPOSE 53

CMD ["/usr/sbin/named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]
