# Supabase Kong API Gateway for Railway

Custom Kong API Gateway image pre-configured for Supabase self-hosting on Railway.

## Features

- Pre-baked kong.yml configuration for Railway internal networking
- Environment variable substitution at runtime
- Configured for all Supabase services (Auth, REST, Realtime, Storage, Functions, etc.)

## Environment Variables

Set these in your Railway service:

| Variable | Description |
|----------|-------------|
| `SUPABASE_ANON_KEY` | Anonymous API key |
| `SUPABASE_SERVICE_KEY` | Service role API key |
| `DASHBOARD_USERNAME` | Studio dashboard username |
| `DASHBOARD_PASSWORD` | Studio dashboard password |

## Railway Deployment

1. Create a new service from this repo
2. Set the required environment variables
3. Deploy

The kong.yml uses Railway's internal networking (`servicename.railway.internal`) for service-to-service communication.

## Service Routes

| Path | Service |
|------|---------|
| `/auth/v1/*` | GoTrue Auth |
| `/rest/v1/*` | PostgREST |
| `/graphql/v1` | GraphQL |
| `/realtime/v1/*` | Realtime |
| `/storage/v1/*` | Storage API |
| `/functions/v1/*` | Edge Functions |
| `/analytics/v1/*` | Logflare |
| `/pg/*` | Postgres Meta |
| `/*` | Studio Dashboard |
