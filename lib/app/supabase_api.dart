import 'package:supabase/supabase.dart';

// use your own SUPABASE_URL
const String SUPABASE_URL = 'https://shjgnntxbdniaaewtcef.supabase.co';

// use your own SUPABASE_SECRET key
const String SUPABASE_SECRET =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNoamdubnR4YmRuaWFhZXd0Y2VmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjcxOTQyNDEsImV4cCI6MTk4Mjc3MDI0MX0.ghW3DWDsCI3vb7yJKPqGuJHaKR-i6RpElpbZ0Ifednk';

final SupabaseClient supabase = SupabaseClient(SUPABASE_URL, SUPABASE_SECRET);
