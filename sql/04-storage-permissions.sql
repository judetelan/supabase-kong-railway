-- Storage Permissions
-- Run these as superuser to fix storage service access

-- Grant full database access to storage admin
GRANT ALL PRIVILEGES ON DATABASE postgres TO supabase_storage_admin;

-- Grant schema permissions
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA public TO supabase_storage_admin;

-- Grant table permissions (run after tables are created)
GRANT ALL ON ALL TABLES IN SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA storage TO supabase_storage_admin;

-- Default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA storage GRANT ALL ON TABLES TO supabase_storage_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA storage GRANT ALL ON SEQUENCES TO supabase_storage_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA storage GRANT ALL ON FUNCTIONS TO supabase_storage_admin;
