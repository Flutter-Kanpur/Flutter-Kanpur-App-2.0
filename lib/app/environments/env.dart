import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Separate Supabase project used by the embedded ReadMe blogs package.
  static String get readmeSupabaseUrl =>
      dotenv.env['README_SUPABASE_URL'] ?? '';
  static String get readmeSupabaseAnonKey =>
      dotenv.env['README_SUPABASE_ANON_KEY'] ?? '';

  /// ReadMe Edge Function that mints a ReadMe session from a Kanpur JWT.
  static String get readmeSyncSessionUrl =>
      dotenv.env['README_SYNC_SESSION_URL'] ?? '';
}
