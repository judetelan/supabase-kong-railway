import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
};

// Hello function handler
async function handleHello(req: Request): Promise<Response> {
  try {
    const body = await req.json().catch(() => ({}));
    const name = body.name || "World";

    return new Response(
      JSON.stringify({
        message: `Hello ${name}!`,
        timestamp: new Date().toISOString(),
        environment: {
          supabaseUrl: Deno.env.get("SUPABASE_URL") ? "configured" : "not set",
          jwtSecret: Deno.env.get("JWT_SECRET") ? "configured" : "not set",
        }
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
}

// Database test function handler
async function handleDbTest(req: Request): Promise<Response> {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseKey) {
      return new Response(
        JSON.stringify({
          error: "Supabase configuration missing",
          supabaseUrl: supabaseUrl ? "set" : "missing",
          supabaseKey: supabaseKey ? "set" : "missing"
        }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabase = createClient(supabaseUrl, supabaseKey);

    return new Response(
      JSON.stringify({
        status: "connected",
        message: "Supabase client initialized successfully",
        supabaseUrl: supabaseUrl,
        timestamp: new Date().toISOString()
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
}

// Echo function - returns request details
async function handleEcho(req: Request): Promise<Response> {
  const url = new URL(req.url);
  const body = await req.text().catch(() => "");

  return new Response(
    JSON.stringify({
      method: req.method,
      url: req.url,
      path: url.pathname,
      query: Object.fromEntries(url.searchParams),
      headers: Object.fromEntries(req.headers),
      body: body || null,
      timestamp: new Date().toISOString()
    }),
    { headers: { ...corsHeaders, "Content-Type": "application/json" } }
  );
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const url = new URL(req.url);
  const path = url.pathname;

  // Health check endpoint
  if (path === "/health" || path === "/") {
    return new Response(
      JSON.stringify({
        status: "ok",
        service: "edge-functions",
        timestamp: new Date().toISOString(),
        functions: ["hello", "db-test", "echo"]
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }

  // Route to functions
  // Pattern: /functions/v1/{function-name} or /{function-name}
  const functionMatch = path.match(/^(?:\/functions\/v1)?\/(.+)/);

  if (functionMatch) {
    const functionName = functionMatch[1].split("/")[0]; // Get first path segment

    switch (functionName) {
      case "hello":
        return await handleHello(req);
      case "db-test":
        return await handleDbTest(req);
      case "echo":
        return await handleEcho(req);
      default:
        return new Response(
          JSON.stringify({
            error: `Function '${functionName}' not found`,
            available: ["hello", "db-test", "echo"],
            hint: "Use /functions/v1/{function-name} or /{function-name}"
          }),
          { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
    }
  }

  return new Response(
    JSON.stringify({
      error: "Not found",
      path: path,
      available: ["hello", "db-test", "echo"],
      hint: "Use /functions/v1/{function-name} or /{function-name}"
    }),
    { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
  );
});
