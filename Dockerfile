#
# Copyright (C) 2019 Olliver Schinagl <oliver@schinagl.nl>
#
# SPDX-License-Identifier: BSD-4-Clause

# For Alpine, latest is actually the latest stable
# hadolint ignore=DL3007
FROM registry.hub.docker.com/library/alpine:latest AS alpine-builder

LABEL Maintainer="Olliver Schinagl <oliver@schinagl.nl>"

WORKDIR /build

# We want the latest stable version from the repo
# hadolint ignore=DL3018
RUN \
    apk add --no-cache \
       autoconf \
       automake \
       build-base \
       brotli-dev \
       curl-dev \
       groff \
       libpsl-dev \
       libssh2-dev \
       libtool \
       rtmpdump-dev \
       zstd-dev \
    && \
    rm -rf "/var/cache/apk/"*

COPY . "/build"

RUN \
    autoreconf -vif && \
    ./configure \
        --disable-ldap \
        --enable-ipv6 \
        --enable-unix-sockets \
        --prefix=/usr \
        --with-libssh2 \
        --with-nghttp2 \
        --with-pic \
        --with-ssl \
        --without-libidn \
        --without-libidn2 \
    && \
    make && \
    make DESTDIR="/builder/" install

# For Alpine, latest is actually the latest stable
# hadolint ignore=DL3007
FROM registry.hub.docker.com/library/alpine:latest

RUN \
    apk add --no-cache \
       brotli-libs \
       libpsl \
       librtmp \
       libssh2 \
       nghttp2-libs \
       zstd-libs \
    && \
    rm -rf "/var/cache/apk/"*

COPY --from=alpine-builder "/builder/usr/bin/" "/usr/bin/"
COPY --from=alpine-builder "/builder/usr/lib/libcurl.so.*" "/usr/lib/"

COPY "scripts/docker-entrypoint.sh" "/docker-entrypoint.sh"

ENTRYPOINT [ "/docker-entrypoint.sh" ]
