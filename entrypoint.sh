#!/usr/bin/env sh
set -e

# Default to running build.sh if the first arg isn't an executable
if ! command -v "$1" &> /dev/null && ! [ \( -f "$1" -a -x "$1" \) ]; then
    set -- /build.sh "$@"
fi

exec "$@"
