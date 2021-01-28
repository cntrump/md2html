FROM pandoc/core AS base

RUN apk update && \
    apk add zsh && \
    rm -rf /var/cache/apk/*

ADD syntax.theme /usr/local/md2html/
ADD template.html /usr/local/md2html/
ADD colors.css /usr/local/md2html/
ADD style.css /usr/local/md2html/
ADD md2html.sh /usr/local/md2html/

WORKDIR /data

ENTRYPOINT ["/usr/local/md2html/md2html.sh"]