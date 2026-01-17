SELECT schemaname, tablename FROM pg_tables WHERE schemaname IN ('public', 'auth') ORDER BY schemaname, tablename;
