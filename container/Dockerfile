FROM alpine:latest

EXPOSE 53 53/udp
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

RUN apk --update upgrade && \
    apk add bind ca-certificates curl gnupg1 && \
    rm -rf /var/cache/apk/* && \
    chmod g-w /var/bind && \
    cp -p /etc/bind/bind.keys /var/bind/ && \
    install -d -m 0770 -o named -g named /var/cache/bind && \
    ln -s ../../var/run/named/rndc.key /etc/bind/rndc.key

COPY configs/. /etc/bind/

# Mounts
# NOTE: Per Dockerfile manual -->
#	"if any build steps change the data within the volume
# 	 after it has been declared, those changes will be discarded."
VOLUME ["/etc/bind", "/var/cache/bind"]

