-- Supabase Schemas Setup
-- Run these as superuser (supabase_admin)

-- Create schemas with proper ownership
CREATE SCHEMA IF NOT EXISTS auth AUTHORIZATION supabase_auth_admin;
CREATE SCHEMA IF NOT EXISTS storage AUTHORIZATION supabase_storage_admin;
CREATE SCHEMA IF NOT EXISTS _realtime;
CREATE SCHEMA IF NOT EXISTS extensions;

-- Grant schema permissions
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT USAGE ON SCHEMA auth TO postgres;
GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;

GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT USAGE ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;

GRANT ALL ON SCHEMA public TO supabase_auth_admin;
GRANT ALL ON SCHEMA public TO supabase_storage_admin;
GRANT ALL ON SCHEMA public TO anon;
GRANT ALL ON SCHEMA public TO authenticated;
GRANT ALL ON SCHEMA public TO service_role;

GRANT ALL ON SCHEMA _realtime TO postgres;
GRANT USAGE ON SCHEMA _realtime TO anon;
GRANT USAGE ON SCHEMA _realtime TO authenticated;
GRANT USAGE ON SCHEMA _realtime TO service_role;

GRANT ALL ON SCHEMA extensions TO postgres;
GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
