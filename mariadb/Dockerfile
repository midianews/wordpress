FROM alpine:latest
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Danton Junior <danton@gmail.com>" \
    architecture="amd64/x86_64" \
    mariadb-version="latest" \
    alpine-version="latest" \
    build="28-May-2020" \
    org.opencontainers.image.title="alpine-mariadb" \
    org.opencontainers.image.description="MariaDB Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Danton Junior <danton@gmail.com>" \
    org.opencontainers.image.vendor="DJ Systems" \
    org.opencontainers.image.version="latest" \
    org.opencontainers.image.url="https://hub.docker.com/repository/docker/midianews/wordpress/" \
    org.opencontainers.image.source="https://github.com/midianews/wordpress/tree/master/" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk update && \
    apk upgrade && \ 
    apk add --no-cache htop mariadb mariadb-client mariadb-server-utils pwgen mariadb-mytop && \
    rm -f /var/cache/apk/*

ADD https://raw.githubusercontent.com/midianews/wordpress/master/mariadb/run.sh /scripts/run.sh
RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]
