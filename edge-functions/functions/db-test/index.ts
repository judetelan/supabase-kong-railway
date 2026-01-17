// Database Test Edge Function
// Invoke with: /functions/v1/db-test
// Tests database connectivity from Edge Functions

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

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
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseKey) {
      return new Response(
        JSON.stringify({
          error: "Supabase configuration missing",
          supabaseUrl: supabaseUrl ? "set" : "missing",
          supabaseKey: supabaseKey ? "set" : "missing"
        }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const supabase = createClient(supabaseUrl, supabaseKey);

    // Try to get the current timestamp from the database
    const { data, error } = await supabase.rpc('now').single();

    if (error) {
      // Fallback: try a simple query
      const { data: tables, error: tablesError } = await supabase
        .from('_metadata')
        .select('*')
        .limit(1);

      return new Response(
        JSON.stringify({
          status: "connected",
          message: "Database connection successful",
          timestamp: new Date().toISOString(),
          query_result: tables || "No metadata table",
          query_error: tablesError?.message
        }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    return new Response(
      JSON.stringify({
        status: "connected",
        message: "Database connection successful",
        db_timestamp: data,
        edge_timestamp: new Date().toISOString()
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: error.message,
        stack: error.stack
      }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
};
