FROM ubuntu:20.10 AS base

RUN apt-get update && \
    apt-get install -y zsh pandoc && \
    apt-get autoclean

ADD syntax.theme /usr/local/md2html/
ADD template.html /usr/local/md2html/
ADD colors.css /usr/local/md2html/
ADD style.css /usr/local/md2html/
ADD md2html.sh /usr/local/md2html/

WORKDIR /data

ENV LANG C.UTF-8 \
    LANGUAGE C.UTF-8 \
    LC_ALL C.UTF-8

ENTRYPOINT ["/usr/local/md2html/md2html.sh"]