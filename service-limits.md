# Railway Service Resource Limits & Sleep Configuration

## Services that CAN sleep (non-critical, on-demand):
- supabase-studio: Dashboard only needed for admin access
- supabase-imgproxy: Only needed for image transformations
- supabase-meta: Only needed for DB management in Studio

## Services that MUST stay awake (critical):
- supabase-db: Database (core)
- supabase-kong: API Gateway (all traffic goes through here)
- supabase-auth: Authentication (required for all auth)
- supabase-rest: PostgREST API (main data API)
- supabase-storage: File storage API
- supabase-realtime: WebSocket subscriptions
- supabase-minio: S3 storage backend

## Recommended Resource Limits (per service):
| Service | Memory | vCPU | Can Sleep |
|---------|--------|------|-----------|
| supabase-db | 1GB | 1 | NO |
| supabase-kong | 512MB | 0.5 | NO |
| supabase-auth | 256MB | 0.25 | NO |
| supabase-rest | 256MB | 0.25 | NO |
| supabase-storage | 256MB | 0.25 | NO |
| supabase-realtime | 512MB | 0.5 | Optional |
| supabase-meta | 256MB | 0.25 | YES |
| supabase-studio | 512MB | 0.5 | YES |
| supabase-imgproxy | 256MB | 0.25 | YES |
| supabase-minio | 512MB | 0.5 | NO |
