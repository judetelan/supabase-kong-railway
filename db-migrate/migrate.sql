-- Supabase user migration script
-- Creates missing users required by Supabase services

\echo 'Creating Supabase roles...'

-- Create roles if they don't exist
DO $$
BEGIN
    -- supabase_auth_admin (required by Auth service)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'supabase_auth_admin') THEN
        CREATE ROLE supabase_auth_admin WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT CREATEROLE;
        RAISE NOTICE 'Created role: supabase_auth_admin';
    ELSE
        ALTER ROLE supabase_auth_admin WITH PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5';
        RAISE NOTICE 'Updated password for: supabase_auth_admin';
    END IF;

    -- supabase_storage_admin (required by Storage service)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'supabase_storage_admin') THEN
        CREATE ROLE supabase_storage_admin WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT;
        RAISE NOTICE 'Created role: supabase_storage_admin';
    ELSE
        ALTER ROLE supabase_storage_admin WITH PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5';
        RAISE NOTICE 'Updated password for: supabase_storage_admin';
    END IF;

    -- supabase_functions_admin (required by Edge Functions)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'supabase_functions_admin') THEN
        CREATE ROLE supabase_functions_admin WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT;
        RAISE NOTICE 'Created role: supabase_functions_admin';
    ELSE
        ALTER ROLE supabase_functions_admin WITH PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5';
        RAISE NOTICE 'Updated password for: supabase_functions_admin';
    END IF;

    -- authenticator (for PostgREST)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticator') THEN
        CREATE ROLE authenticator WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT;
        RAISE NOTICE 'Created role: authenticator';
    ELSE
        ALTER ROLE authenticator WITH PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5';
        RAISE NOTICE 'Updated password for: authenticator';
    END IF;

    -- pgbouncer (for connection pooling)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'pgbouncer') THEN
        CREATE ROLE pgbouncer WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5';
        RAISE NOTICE 'Created role: pgbouncer';
    ELSE
        ALTER ROLE pgbouncer WITH PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5';
        RAISE NOTICE 'Updated password for: pgbouncer';
    END IF;

    -- anon role (public API access)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'anon') THEN
        CREATE ROLE anon NOLOGIN NOINHERIT;
        RAISE NOTICE 'Created role: anon';
    END IF;

    -- authenticated role (authenticated API access)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated NOLOGIN NOINHERIT;
        RAISE NOTICE 'Created role: authenticated';
    END IF;

    -- service_role (service-level API access)
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'service_role') THEN
        CREATE ROLE service_role NOLOGIN NOINHERIT BYPASSRLS;
        RAISE NOTICE 'Created role: service_role';
    END IF;
END
$$;

\echo 'Granting role memberships...'

-- Grant role memberships (ignore errors if already granted)
DO $$
BEGIN
    GRANT anon TO authenticator;
    GRANT authenticated TO authenticator;
    GRANT service_role TO authenticator;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Some grants may already exist';
END
$$;

\echo 'Creating schemas...'

-- Create schemas if not exist
CREATE SCHEMA IF NOT EXISTS auth AUTHORIZATION supabase_auth_admin;
CREATE SCHEMA IF NOT EXISTS storage AUTHORIZATION supabase_storage_admin;
CREATE SCHEMA IF NOT EXISTS extensions;

\echo 'Granting schema usage...'

-- Grant schema usage
GRANT USAGE ON SCHEMA auth TO supabase_auth_admin, postgres;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT USAGE ON SCHEMA storage TO supabase_storage_admin, postgres;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT USAGE ON SCHEMA extensions TO public;

\echo 'Enabling extensions...'

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

\echo 'Supabase roles setup completed successfully!'

SELECT 'Migration completed!' as status;
