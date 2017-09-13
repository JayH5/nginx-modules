# nginx-modules

[![GitHub release](https://img.shields.io/github/release/praekeltfoundation/nginx-modules.svg?style=flat-square)](https://github.com/praekeltfoundation/nginx-modules/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/nginx-module-builder.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/nginx-module-builder/)
[![Travis branch](https://img.shields.io/travis/praekeltfoundation/nginx-modules/master.svg?style=flat-square)](https://travis-ci.org/praekeltfoundation/nginx-modules)

Some Nginx dynamic modules and the Docker images used to build them 🏗

## What is this?
These are builds of some 3rd party modules for Nginx. Since Nginx 1.9.11, it's been possible to add modules to an existing Nginx installation. These are called "dynamic modules". Previously it was necessary to rebuild the whole of Nginx with the new modules.

Unfortunately, there are still some limitation. It's still necessary to build the modules against the same version of Nginx and with the same compile-time configuration options as the existing Nginx installation.

This repo is an attempt to build some of the modules we use--or would like to use, mostly for the [`django-bootstrap`](https://github.com/praekeltfoundation/docker-django-bootstrap) project.

Modules are currently built against the latest stable Nginx release, with the intention to be compatible with Nginx as present in the [official Nginx Docker images](https://github.com/nginxinc/docker-nginx). Note that this means that these built modules will *not* be compatible with the Nginx provided in the standard package repositories for most distros.

Currently modules are **only built for Debian Jessie** (8). It is our intention to build these modules for newer Debian releases as well as Alpine Linux.

## Modules
* [Nginx Development Kit](https://github.com/simpl/ngx_devel_kit) (`ndk_http_module`)
* [Nginx Lua module](https://github.com/openresty/lua-nginx-module) (`ngx_http_lua_module`)

## Build artifacts
This repo is built by Travis CI and produces both a set of compiled module shared libraries (`.so` files) and the built Docker images used to produce those modules. The modules are available from the [Releases page](https://github.com/praekeltfoundation/nginx-modules/releases), while the Docker images are available on [Docker Hub](https://hub.docker.com/r/praekeltfoundation/nginx-module-builder).
