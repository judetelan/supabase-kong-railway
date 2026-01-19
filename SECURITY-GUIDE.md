# Supabase Railway Security Guide

## 🔴 CRITICAL: Studio Access Security

Your Supabase Studio is currently **publicly accessible**. Anyone with the URL can:
- View all your database tables
- Execute SQL queries
- Manage authentication users
- Access storage files
- View API keys and secrets

## Immediate Actions Required

### Option 1: Private Networking (Recommended)

Make Studio accessible only within Railway's private network:

1. Go to Railway Dashboard → Your Project
2. Click on the **supabase-studio** service
3. Go to **Settings** → **Networking**
4. Toggle OFF "Public Networking"
5. Keep only "Private Networking" enabled

Then access Studio via Railway CLI:
```bash
railway run --service supabase-studio -- curl localhost:3000
```

Or use Railway's TCP Proxy for local access.

### Option 2: Basic Auth via Gateway

Route Studio through the gateway with password protection:

1. Generate a bcrypt password hash:
```bash
# Using htpasswd (Apache)
htpasswd -nbB admin your_secure_password

# Or using caddy
docker run --rm caddy caddy hash-password --plaintext 'your_secure_password'
```

2. Set these environment variables on the **gateway** service:
```
STUDIO_USER=admin
STUDIO_PASSWORD_HASH=$2a$14$... (your bcrypt hash)
CORS_ORIGIN=https://yourdomain.com
```

3. Access Studio at: `https://your-gateway.up.railway.app/studio/`

### Option 3: IP Whitelisting (Enterprise Feature)

If you have Railway Enterprise:
1. Configure allowed IP ranges in service settings
2. Only your office/VPN IPs can access Studio

## Environment Variables Security

### Current Issues:
- `vars-studio.json` contains hardcoded secrets
- If your repo is public, secrets are exposed

### Fix:
1. **Never commit secrets to git**
2. Use Railway's environment variable UI instead
3. Reference variables with `${{VARIABLE_NAME}}` in config files

### Required Secrets (set in Railway UI):
```
JWT_SECRET=your-jwt-secret-min-32-chars
ANON_KEY=your-anon-key
SERVICE_ROLE_KEY=your-service-role-key
POSTGRES_PASSWORD=your-db-password
```

## CORS Configuration

### Current:
```
Access-Control-Allow-Origin: *
```
This allows ANY website to call your API.

### Recommended:
Set the `CORS_ORIGIN` environment variable on gateway:
```
CORS_ORIGIN=https://myapp.com
```

For multiple origins, update Caddyfile to use a list.

## API Key Security

### Public (anon) Key:
- Safe to expose in frontend code
- Limited by Row Level Security (RLS)
- Configure RLS policies in Studio

### Service Role Key:
- **NEVER expose in frontend code**
- Full database access, bypasses RLS
- Use only in backend/server functions

## Database Security

### Enable RLS on All Tables:
```sql
ALTER TABLE your_table ENABLE ROW LEVEL SECURITY;

-- Example policy: Users can only see their own data
CREATE POLICY "Users can view own data" ON your_table
  FOR SELECT USING (auth.uid() = user_id);
```

### Revoke Public Access:
```sql
-- Remove direct table access
REVOKE ALL ON your_table FROM anon;
REVOKE ALL ON your_table FROM authenticated;

-- Grant via RLS policies only
GRANT SELECT ON your_table TO authenticated;
```

## Monitoring & Alerts

### Set Up Logging:
1. Enable `pgaudit` extension (already loaded)
2. Configure log retention in Railway
3. Set up alerts for failed auth attempts

### Railway Observability:
1. Go to your project settings
2. Enable "Observability"
3. Configure alerts for:
   - High error rates
   - Unusual traffic patterns
   - Service restarts

## Security Checklist

- [ ] Studio access restricted (private network or basic auth)
- [ ] CORS restricted to specific domains
- [ ] Secrets removed from git, using Railway env vars
- [ ] RLS enabled on all tables
- [ ] Service role key not exposed in frontend
- [ ] Database connection uses SSL
- [ ] Regular secret rotation scheduled
- [ ] Monitoring and alerts configured

## Emergency: If Compromised

1. **Rotate all secrets immediately:**
   - Generate new JWT_SECRET
   - Generate new API keys
   - Change POSTGRES_PASSWORD

2. **Revoke all sessions:**
   ```sql
   DELETE FROM auth.sessions;
   DELETE FROM auth.refresh_tokens;
   ```

3. **Check for unauthorized data access:**
   - Review pgaudit logs
   - Check for unknown users in auth.users
   - Verify storage files

4. **Update all clients** with new API keys

---

## Quick Security Setup Commands

```bash
# 1. Generate new JWT secret
openssl rand -base64 32

# 2. Generate bcrypt hash for Studio password
docker run --rm caddy caddy hash-password --plaintext 'YourSecurePassword123!'

# 3. Update Railway env vars
railway variables set JWT_SECRET="your-new-secret" --service supabase-auth
railway variables set STUDIO_PASSWORD_HASH='$2a$14$...' --service supabase-gateway
```

## Contact

For security issues with this template, create a private issue or contact the maintainer directly.
