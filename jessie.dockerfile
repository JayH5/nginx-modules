FROM debian:jessie

# Get the Nginx build deps, source, and config options
ENV NGINX_VERSION 1.12.1-1~jessie
ENV NGINX_GPG_KEY 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN set -ex; \
# Add the APT key & source
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "$NGINX_GPG_KEY"; \
    echo 'deb http://nginx.org/packages/debian/ jessie nginx' > /etc/apt/sources.list.d/nginx.list; \
    echo 'deb-src http://nginx.org/packages/debian/ jessie nginx' >> /etc/apt/sources.list.d/nginx.list; \
    apt-get update; \
    \
# Install the build dependencies
    apt-get build-dep -y "nginx=$NGINX_VERSION"; \
    \
# Download the source
    apt-get source "nginx=$NGINX_VERSION"; \
    mkdir -p /usr/src; \
    mv "nginx-${NGINX_VERSION%-*}" /usr/src/nginx; \
    rm nginx*; \
    \
# Grab the built Nginx's config options
    apt-get install -y --no-install-recommends "nginx=$NGINX_VERSION"; \
    nginx -V 2>&1 | grep 'configure arguments' | cut -d':' -f2 > /nginx_configure_args; \
    apt-get purge -y --auto-remove nginx; \
    \
    rm -rf /var/lib/apt/lists/*

# Additional dependency needed for Lua Nginx module
RUN apt-get update \
    && apt-get install -y --no-install-recommends libluajit-5.1-dev \
    && rm -rf /var/lib/apt/lists/*
ENV LUAJIT_LIB=/usr/lib/x86_64-linux-gnu \
    LUAJIT_INC=/usr/include/luajit-2.0

WORKDIR /usr/src/nginx
VOLUME /usr/src/nginx/objs

COPY build.sh entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
