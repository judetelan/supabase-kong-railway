# Supabase Railway Deployment - Production Endpoints

## 🚀 PRODUCTION UNIFIED GATEWAY (Recommended)

**URL:** `https://supabase-gateway-production-43cb.up.railway.app`

The unified gateway provides a single entry point for all Supabase services:

| Path | Service | Description |
|------|---------|-------------|
| `/rest/v1/*` | PostgREST | Database REST API |
| `/auth/v1/*` | GoTrue | Authentication |
| `/storage/v1/*` | Storage | File storage |
| `/functions/v1/*` | Edge Functions | Serverless functions |
| `/pg/*` | pg-meta | Database metadata |
| `/realtime/v1/*` | Realtime | WebSocket subscriptions |
| `/health` | Gateway | Health check |

### Using with Supabase JS Client

```javascript
import { createClient } from '@supabase/supabase-js'

const GATEWAY_URL = 'https://supabase-gateway-production-43cb.up.railway.app'
const ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzAwMDAwMDAwLCJleHAiOjIwMDAwMDAwMDB9.b26_5wWYPrbBx61BdofRbC78NhUPSXq-Cgt9JqSrZdE'

// Note: For full Supabase client compatibility, use direct service URLs
// The gateway is ideal for REST API, Auth, and Storage operations

const supabase = createClient(
  'https://supabase-rest-production.up.railway.app',
  ANON_KEY,
  {
    auth: {
      url: 'https://supabase-auth-production-c390.up.railway.app'
    },
    realtime: {
      url: 'wss://supabase-realtime-production-8f0e.up.railway.app/socket'
    }
  }
)
```

---

## API Credentials

```
JWT_SECRET=e17c6f771da57efb5f2c5df301edab5236942a83a37c5522178f014435f4fa1b

SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzAwMDAwMDAwLCJleHAiOjIwMDAwMDAwMDB9.b26_5wWYPrbBx61BdofRbC78NhUPSXq-Cgt9JqSrZdE

SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3MDAwMDAwMDAsImV4cCI6MjAwMDAwMDAwMH0.k9OdWmHxgtiMW3in1Ya489HcwWrcZ243WbYqgjhuQAA
```

---

## Direct Service Endpoints

### REST API (PostgREST) ✅
**URL:** `https://supabase-rest-production.up.railway.app`

```bash
# Get OpenAPI spec
curl https://supabase-rest-production.up.railway.app/ \
  -H "Authorization: Bearer <ANON_KEY>" \
  -H "apikey: <ANON_KEY>"

# Query a table
curl https://supabase-rest-production.up.railway.app/your_table \
  -H "Authorization: Bearer <ANON_KEY>" \
  -H "apikey: <ANON_KEY>"
```

### Auth (GoTrue) ✅
**URL:** `https://supabase-auth-production-c390.up.railway.app`

```bash
# Health check
curl https://supabase-auth-production-c390.up.railway.app/health

# Sign up
curl -X POST https://supabase-auth-production-c390.up.railway.app/signup \
  -H "Content-Type: application/json" \
  -H "apikey: <ANON_KEY>" \
  -d '{"email":"user@example.com","password":"password123"}'
```

### Storage ✅
**URL:** `https://supabase-storage-production-cfd8.up.railway.app`

```bash
# Status check
curl https://supabase-storage-production-cfd8.up.railway.app/status

# Upload file
curl -X POST https://supabase-storage-production-cfd8.up.railway.app/object/bucket/path \
  -H "Authorization: Bearer <SERVICE_KEY>" \
  -F "file=@yourfile.txt"
```

### Realtime ✅
**URL:** `https://supabase-realtime-production-8f0e.up.railway.app`
**WebSocket:** `wss://supabase-realtime-production-8f0e.up.railway.app/socket`

### Meta (pg-meta) ✅
**URL:** `https://supabase-meta-production.up.railway.app`

```bash
# Health check
curl https://supabase-meta-production.up.railway.app/health
```

### Studio (Dashboard) ✅
**URL:** `https://supabase-studio-production-daa2.up.railway.app`
**Credentials:** supabase / bNnM9GVRWo3Lgmq0

The Studio dashboard provides:
- Table Editor
- SQL Editor
- Authentication Users
- Storage Buckets
- API Documentation

### Edge Functions ✅
**URL:** `https://supabase-edge-functions-production.up.railway.app`

Available functions:
- `hello` - Hello world test function
- `db-test` - Database connectivity test
- `echo` - Request echo/debugging

```bash
# Hello function
curl https://supabase-edge-functions-production.up.railway.app/functions/v1/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "World"}'

# Database test
curl https://supabase-edge-functions-production.up.railway.app/functions/v1/db-test

# Echo (debugging)
curl https://supabase-edge-functions-production.up.railway.app/functions/v1/echo \
  -d '{"test": "data"}'

# Health check
curl https://supabase-edge-functions-production.up.railway.app/health
```

### Unified Gateway (Caddy) ✅
**URL:** `https://supabase-gateway-production-43cb.up.railway.app`

Routes all services through a single endpoint with path-based routing.

---

## Database Connection

**Host:** supabase-db-production-c2ca.up.railway.app
**Port:** 5432
**User:** postgres
**Password:** fc1c9eb6125a7f3f79d9a9681f734ad5
**Database:** postgres

Connection string:
```
postgres://postgres:fc1c9eb6125a7f3f79d9a9681f734ad5@supabase-db-production-c2ca.up.railway.app:5432/postgres
```

---

## Service Status

| Service | Status | URL |
|---------|--------|-----|
| Database | ✅ Running | supabase-db-production-c2ca.up.railway.app:5432 |
| REST API | ✅ Running | https://supabase-rest-production.up.railway.app |
| Auth | ✅ Running | https://supabase-auth-production-c390.up.railway.app |
| Storage | ✅ Running | https://supabase-storage-production-cfd8.up.railway.app |
| Realtime | ✅ Running | https://supabase-realtime-production-8f0e.up.railway.app |
| Meta | ✅ Running | https://supabase-meta-production.up.railway.app |
| Studio | ✅ Running | https://supabase-studio-production-daa2.up.railway.app |
| Edge Functions | ✅ Running | https://supabase-edge-functions-production.up.railway.app |
| **Gateway** | ✅ Running | https://supabase-gateway-production-43cb.up.railway.app |
| Kong | ⚠️ Bypassed | (replaced by Caddy gateway) |

---

## Quick Test Commands

```bash
# Test all services through gateway
curl https://supabase-gateway-production-43cb.up.railway.app/health
curl https://supabase-gateway-production-43cb.up.railway.app/auth/v1/health
curl https://supabase-gateway-production-43cb.up.railway.app/rest/v1/ -H "apikey: <ANON_KEY>"
curl https://supabase-gateway-production-43cb.up.railway.app/storage/v1/status
curl https://supabase-gateway-production-43cb.up.railway.app/functions/v1/hello -d '{"name":"Test"}'
```
