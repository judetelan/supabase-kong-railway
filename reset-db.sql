-- Complete reset of Supabase schemas and migration tracking
DROP TABLE IF EXISTS public.schema_migrations CASCADE;
DROP SCHEMA IF EXISTS auth CASCADE;
DROP SCHEMA IF EXISTS storage CASCADE;
DROP SCHEMA IF EXISTS realtime CASCADE;

-- Recreate schemas
CREATE SCHEMA auth AUTHORIZATION supabase_auth_admin;
CREATE SCHEMA storage AUTHORIZATION supabase_storage_admin;

-- Grant permissions
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT USAGE ON SCHEMA auth TO postgres;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT USAGE ON SCHEMA storage TO postgres;
GRANT ALL ON SCHEMA public TO supabase_auth_admin;
GRANT ALL ON SCHEMA public TO supabase_storage_admin;

SELECT 'Database reset complete' as status;
