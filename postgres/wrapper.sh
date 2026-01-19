#!/bin/bash

# exit as soon as any of these commands fail, this prevents starting a database without certificates
set -e

# Fix permissions for Railway volume mount
# This runs as root before switching to postgres user
if [ "$(id -u)" = '0' ]; then
    echo "Running as root - setting up directory permissions..."
    mkdir -p /var/lib/postgresql/data
    chown -R postgres:postgres /var/lib/postgresql
    chmod 700 /var/lib/postgresql/data
    echo "Directory permissions set, restarting as postgres user..."
    exec gosu postgres "$0" "$@"
fi

# Make sure there is a PGDATA variable available
if [ -z "$PGDATA" ]; then
  echo "Missing PGDATA variable"
  exit 1
fi

# unset PGHOST to force psql to use Unix socket path
# this is specific to Railway and allows
# us to use PGHOST after the init
unset PGHOST

## unset PGPORT also specific to Railway
## since postgres checks for validity of
## the value in PGPORT we unset it in case
## it ends up being empty
unset PGPORT

# For some reason postgres doesn't want to respect our DBDATA variable. So we need to replace it
sed -i -e 's/data_directory = '\''\/var\/lib\/postgresql\/data'\''/data_directory = '\''\/var\/lib\/postgresql\/data\/pgdata'\''/g' /etc/postgresql/postgresql.conf

# https://github.com/supabase/postgres/blob/c45336c611971037c2cc9fa21045870d225f80d5/Dockerfile-16
# Create custom config directory structure
mkdir -p /var/lib/postgresql/data/custom/conf.d
chown -R postgres:postgres /var/lib/postgresql/data/custom

# Create required config files if they don't exist
if [[ ! -f "/var/lib/postgresql/data/custom/supautils.conf" ]]; then
  touch /var/lib/postgresql/data/custom/supautils.conf
  chown postgres:postgres /var/lib/postgresql/data/custom/supautils.conf
fi

# Setup /etc/postgresql-custom symlink
if [[ -d "/etc/postgresql-custom" && ! -L "/etc/postgresql-custom" ]]; then
  if ls /etc/postgresql-custom/* 1> /dev/null 2>&1; then
    cp -arf /etc/postgresql-custom/* /var/lib/postgresql/data/custom/ 2>/dev/null || true
  fi
  rm -rf /etc/postgresql-custom 2>/dev/null || true
fi
ln -sf /var/lib/postgresql/data/custom /etc/postgresql-custom 2>/dev/null || true

# Call the entrypoint script with the
# appropriate PGHOST & PGPORT and redirect
# the output to stdout if LOG_TO_STDOUT is true
if [[ "$LOG_TO_STDOUT" == "true" ]]; then
    /usr/local/bin/docker-entrypoint.sh "$@" 2>&1
else
    /usr/local/bin/docker-entrypoint.sh "$@"
fi
