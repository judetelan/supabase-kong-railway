#!/bin/sh
# Custom entrypoint that runs minio regardless of arguments
# If "server" is passed as first arg, prepend minio
if [ "$1" = "server" ]; then
    exec /usr/bin/minio "$@"
else
    exec /usr/bin/minio server /data --console-address :9001
fi
