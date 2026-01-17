# Migration job to create missing Supabase users
FROM postgres:15-alpine

# Force cache bust
ARG CACHE_BUST=1
RUN echo "Cache bust: ${CACHE_BUST}"

# Copy migration script
COPY migrate.sql /migrate.sql

# Run migration and exit
ENTRYPOINT ["sh", "-c"]
CMD ["echo 'Starting migration...' && PGPASSWORD=\"$POSTGRES_PASSWORD\" psql -h \"$DB_HOST\" -p 5432 -U \"$POSTGRES_USER\" -d \"$POSTGRES_DB\" -f /migrate.sql && echo 'Migration complete!' && sleep 10"]
