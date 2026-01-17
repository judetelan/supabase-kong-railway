// Hello World Edge Function
// Invoke with: /functions/v1/hello

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

export default async (req: Request): Promise<Response> => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { name } = await req.json().catch(() => ({ name: "World" }));

    const data = {
      message: `Hello ${name}!`,
      timestamp: new Date().toISOString(),
      environment: {
        supabaseUrl: Deno.env.get("SUPABASE_URL") ? "configured" : "not set",
        jwtSecret: Deno.env.get("JWT_SECRET") ? "configured" : "not set",
      }
    };

    return new Response(
      JSON.stringify(data),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
};
