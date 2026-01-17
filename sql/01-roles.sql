-- Supabase Roles Setup
-- Run these as superuser (supabase_admin)

-- Create the core Supabase roles
CREATE ROLE supabase_auth_admin WITH LOGIN PASSWORD 'your-auth-password' NOINHERIT CREATEROLE;
CREATE ROLE supabase_storage_admin WITH LOGIN PASSWORD 'your-storage-password' NOINHERIT;
CREATE ROLE authenticator WITH LOGIN PASSWORD 'your-auth-password' NOINHERIT;
CREATE ROLE anon NOLOGIN NOINHERIT;
CREATE ROLE authenticated NOLOGIN NOINHERIT;
CREATE ROLE service_role NOLOGIN NOINHERIT BYPASSRLS;
CREATE ROLE postgres WITH LOGIN SUPERUSER;

-- Grant role memberships
GRANT anon TO authenticator;
GRANT authenticated TO authenticator;
GRANT service_role TO authenticator;
GRANT supabase_auth_admin TO authenticator;
GRANT supabase_storage_admin TO authenticator;

-- Grant database permissions
GRANT ALL ON DATABASE postgres TO supabase_auth_admin;
GRANT ALL ON DATABASE postgres TO supabase_storage_admin;
GRANT CONNECT ON DATABASE postgres TO anon;
GRANT CONNECT ON DATABASE postgres TO authenticated;
GRANT CONNECT ON DATABASE postgres TO service_role;
