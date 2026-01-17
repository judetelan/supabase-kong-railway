// Test Supabase client with unified gateway
import { createClient } from '@supabase/supabase-js';

const GATEWAY_URL = 'https://supabase-gateway-production-43cb.up.railway.app';
const ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzAwMDAwMDAwLCJleHAiOjIwMDAwMDAwMDB9.b26_5wWYPrbBx61BdofRbC78NhUPSXq-Cgt9JqSrZdE';

// For unified gateway approach, we need to configure custom URLs
const supabase = createClient(GATEWAY_URL + '/rest/v1', ANON_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
  global: {
    headers: {
      apikey: ANON_KEY,
    },
  },
});

async function testConnection() {
  console.log('Testing Supabase connection via unified gateway...\n');

  // Test REST API
  console.log('1. Testing REST API...');
  try {
    const { data, error } = await supabase.from('_test').select('*').limit(1);
    if (error && error.code === '42P01') {
      console.log('   ✅ REST API connected (table does not exist, but connection works)\n');
    } else if (error) {
      console.log('   ⚠️ REST API error:', error.message, '\n');
    } else {
      console.log('   ✅ REST API connected\n');
    }
  } catch (e) {
    console.log('   ❌ REST API failed:', e.message, '\n');
  }

  // Test Auth endpoint directly
  console.log('2. Testing Auth service...');
  try {
    const response = await fetch(GATEWAY_URL + '/auth/v1/health');
    const data = await response.json();
    console.log('   ✅ Auth service:', data.name, data.version, '\n');
  } catch (e) {
    console.log('   ❌ Auth failed:', e.message, '\n');
  }

  // Test Storage endpoint
  console.log('3. Testing Storage service...');
  try {
    const response = await fetch(GATEWAY_URL + '/storage/v1/status');
    if (response.ok) {
      console.log('   ✅ Storage service connected\n');
    } else {
      console.log('   ⚠️ Storage status:', response.status, '\n');
    }
  } catch (e) {
    console.log('   ❌ Storage failed:', e.message, '\n');
  }

  // Test Edge Functions
  console.log('4. Testing Edge Functions...');
  try {
    const response = await fetch(GATEWAY_URL + '/functions/v1/hello', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Production' }),
    });
    const data = await response.json();
    console.log('   ✅ Edge Functions:', data.message, '\n');
  } catch (e) {
    console.log('   ❌ Edge Functions failed:', e.message, '\n');
  }

  console.log('All tests completed!');
}

testConnection().catch(console.error);
