const { Client } = require('pg');

const client = new Client({
  host: 'supabase-db-production-c2ca.up.railway.app',
  port: 443,
  user: 'supabase_admin',
  password: 'fc1c9eb6125a7f3f79d9a9681f734ad5',
  database: 'postgres',
  ssl: { rejectUnauthorized: false }
});

const migration = `
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'supabase_auth_admin') THEN
        CREATE ROLE supabase_auth_admin WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT CREATEROLE;
        RAISE NOTICE 'Created role: supabase_auth_admin';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'supabase_storage_admin') THEN
        CREATE ROLE supabase_storage_admin WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT;
        RAISE NOTICE 'Created role: supabase_storage_admin';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticator') THEN
        CREATE ROLE authenticator WITH LOGIN PASSWORD 'fc1c9eb6125a7f3f79d9a9681f734ad5' NOINHERIT;
        RAISE NOTICE 'Created role: authenticator';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'anon') THEN
        CREATE ROLE anon NOLOGIN NOINHERIT;
        RAISE NOTICE 'Created role: anon';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated NOLOGIN NOINHERIT;
        RAISE NOTICE 'Created role: authenticated';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'service_role') THEN
        CREATE ROLE service_role NOLOGIN NOINHERIT BYPASSRLS;
        RAISE NOTICE 'Created role: service_role';
    END IF;

    GRANT anon TO authenticator;
    GRANT authenticated TO authenticator;
    GRANT service_role TO authenticator;

    CREATE SCHEMA IF NOT EXISTS auth AUTHORIZATION supabase_auth_admin;
    GRANT USAGE ON SCHEMA auth TO supabase_auth_admin, postgres;
    GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
END
$$;
`;

async function runMigration() {
  try {
    console.log('Connecting to database...');
    await client.connect();
    console.log('Connected! Running migration...');

    const result = await client.query(migration);
    console.log('Migration completed successfully!');

    // Verify roles
    const roles = await client.query("SELECT rolname FROM pg_roles WHERE rolname IN ('supabase_auth_admin', 'authenticator', 'anon', 'authenticated', 'service_role')");
    console.log('Created roles:', roles.rows.map(r => r.rolname));

  } catch (err) {
    console.error('Migration failed:', err.message);
  } finally {
    await client.end();
  }
}

runMigration();
