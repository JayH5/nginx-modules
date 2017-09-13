#!/usr/bin/env sh
set -e

self="$(basename "$0")"
usage_error() {
	cat <<-EOU >&2
		error: $1
		usage: $self [<configure-args-file>] [<module-source-directory>...]
		 e.g.: $self /nginx_configure_args /usr/src/ngx_devel_kit /usr/src/lua-nginx-module

		where:
			configure-args-file:
				path to a file to read configure arguments (default: /nginx_configure_args)
			module-source-directory:
				path to a directory containing module source code
	EOU
	exit 1
}

CONFIGURE_ARGS_FILE=/nginx_configure_args
if [ -f "$1" ]; then
	CONFIGURE_ARGS_FILE="$1"; shift
fi

MODULE_ARGS=
for source in "$@"; do
	if ! [ -d "$source" ]; then
		usage_error "'$source' is not a directory"
	fi
	MODULE_ARGS="$MODULE_ARGS --add-dynamic-module=$source"
done

cat "$CONFIGURE_ARGS_FILE" | xargs /usr/src/nginx/configure $MODULE_ARGS
make -C /usr/src/nginx modules
