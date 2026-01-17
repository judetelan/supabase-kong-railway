FROM supabase/edge-runtime:v1.69.28

# Copy functions to the container
COPY ./functions /home/deno/functions

# Environment variables (set via Railway)
# JWT_SECRET - JWT secret for verification
# SUPABASE_URL - URL to API gateway or REST service
# SUPABASE_ANON_KEY - Anonymous key
# SUPABASE_SERVICE_ROLE_KEY - Service role key
# SUPABASE_DB_URL - Database connection string
# VERIFY_JWT - Whether to verify JWT (true/false)

EXPOSE 9000

# Start the edge runtime with main service
CMD ["start", "--main-service", "/home/deno/functions/main"]
