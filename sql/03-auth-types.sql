-- Auth Schema Types
-- Run these as supabase_auth_admin or superuser

-- Create enum types in auth schema (required by supabase-auth)
CREATE TYPE auth.factor_type AS ENUM ('totp', 'webauthn', 'phone');
CREATE TYPE auth.factor_status AS ENUM ('unverified', 'verified');
CREATE TYPE auth.aal_level AS ENUM ('aal1', 'aal2', 'aal3');
CREATE TYPE auth.code_challenge_method AS ENUM ('s256', 'plain');
CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);

-- Ensure ownership is correct
ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;
ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;
ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;
ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;
ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;
