import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Replace with your actual Supabase project URL (should look like: https://xxxxx.supabase.co)
  static const String supabaseUrl = 'https://cfvwrqtvghsdbvaoimge.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNmdndycXR2Z2hzZGJ2YW9pbWdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzMjc1NTcsImV4cCI6MjA4ODkwMzU1N30.WXB9gL1jqPsm1_NvaBnlsXTt94cTcgV8IgYVXZiEH6I';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
