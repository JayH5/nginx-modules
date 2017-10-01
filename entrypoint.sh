#!/usr/bin/env sh
set -e

# Default to running build.sh if the first arg is a directory or file that is
# not executable
if [ -d "$1" ] || [ \( -f "$1" -a ! -x "$1" \) ]; then
    set -- /build.sh "$@"
fi

exec "$@"
