FROM supabase/studio:20250113-83c9420

# Required environment variables for Studio
ENV HOSTNAME="0.0.0.0"
ENV DEFAULT_ORGANIZATION_NAME="Default Organization"
ENV DEFAULT_PROJECT_NAME="Default Project"

# These will be set via Railway environment variables:
# STUDIO_PG_META_URL - URL to Meta service
# SUPABASE_URL - URL to API (REST/Kong)
# SUPABASE_PUBLIC_URL - Public URL of Studio
# SUPABASE_ANON_KEY - Anonymous key
# SUPABASE_SERVICE_KEY - Service role key
# AUTH_JWT_SECRET - JWT secret
# POSTGRES_PASSWORD - Database password

EXPOSE 3000

# Health check
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/platform/profile || exit 1
