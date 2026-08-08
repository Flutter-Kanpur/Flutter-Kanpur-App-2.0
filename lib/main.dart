import 'package:Readme/core/config/readme_host.dart';
import 'package:Readme/core/network/readme_supabase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_knp_mobile_app_v2/app/app.dart';
import 'package:flutter_knp_mobile_app_v2/app/environments/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
  );

  // ReadMe blogs live on a different Supabase project than the main app.
  // Bind a dedicated client so article queries hit the correct database.
  final readmeUrl = Env.readmeSupabaseUrl;
  final readmeKey = Env.readmeSupabaseAnonKey;
  if (readmeUrl.isNotEmpty && readmeKey.isNotEmpty) {
    ReadmeSupabase.bind(SupabaseClient(readmeUrl, readmeKey));
  }

  // Hide logout / delete account / app version — account lives in Kanpur.
  ReadmeHost.configure(embedded: true);

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('hi')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const FlutterKanpurApp(),
      ),
    ),
  );
}
