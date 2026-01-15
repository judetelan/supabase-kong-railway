#!/bin/bash
set -e

# Substitute environment variables in kong.yml
envsubst '${SUPABASE_ANON_KEY} ${SUPABASE_SERVICE_KEY} ${DASHBOARD_USERNAME} ${DASHBOARD_PASSWORD}' \
    < /var/lib/kong/kong.yml.template > /var/lib/kong/kong.yml

# Start Kong
exec kong docker-start
