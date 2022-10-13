FROM alpine:3.9

RUN apk add --update --no-cache openssh bash bind-tools curl jq dnsutils

ADD entrypoint.sh /entrypoint.sh
ADD scripts /scripts

ENTRYPOINT ["/entrypoint.sh"]
