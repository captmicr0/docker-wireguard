FROM alpine:3

RUN apk add --no-cache \
	findutils openresolv iptables ip6tables iproute2 wireguard-tools

COPY entrypoint.sh /entrypoint.sh

LABEL org.opencontainers.image.source="https://github.com/captmicr0/docker-wireguard"

ENTRYPOINT ["/entrypoint.sh"]
