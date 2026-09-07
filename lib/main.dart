import 'dart:async';

import 'package:Readme/core/config/readme_host.dart';
import 'package:Readme/core/network/readme_supabase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_knp_mobile_app_v2/app/app.dart';
import 'package:flutter_knp_mobile_app_v2/app/environments/env.dart';
import 'package:flutter_knp_mobile_app_v2/modules/blogs/data/readme_auth_bridge.dart';
import 'package:flutter_knp_mobile_app_v2/utils/network_connectivity_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    _installSupabaseOfflineGuard();

    await EasyLocalization.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await NetworkConnectivityService.instance.initialize();

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
      _listenForReadmeAuthBridge();
      unawaited(_bootstrapReadmeAuthWhenOnline());
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
  }, _handleUncaughtZoneError);
}

/// Supabase auto-refreshes expired sessions in the background; when the
/// emulator/device is offline that surfaces as an unhandled async error.
void _installSupabaseOfflineGuard() {
  final previousHandler = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stack) {
    if (_isSupabaseOfflineAuthError(error)) {
      debugPrint('Supabase auth refresh skipped (offline): $error');
      return true;
    }
    return previousHandler?.call(error, stack) ?? false;
  };
}

void _handleUncaughtZoneError(Object error, StackTrace stack) {
  if (_isSupabaseOfflineAuthError(error)) {
    debugPrint('Supabase auth refresh skipped (offline): $error');
    return;
  }
  FlutterError.presentError(
    FlutterErrorDetails(exception: error, stack: stack),
  );
}

bool _isSupabaseOfflineAuthError(Object error) {
  if (error is AuthRetryableFetchException) return true;
  final message = error.toString();
  return message.contains('AuthRetryableFetchException') &&
      message.contains('Failed host lookup');
}

Future<void> _bootstrapReadmeAuthWhenOnline() async {
  if (Supabase.instance.client.auth.currentSession == null) return;

  final online =
      await NetworkConnectivityService.instance.checkInternetConnection();
  if (!online) {
    _retryReadmeAuthWhenOnline();
    return;
  }

  await ReadmeAuthBridge.ensureSignedIn(
    force: !ReadmeAuthBridge.readmeSessionMatchesHost(),
  );
}

void _retryReadmeAuthWhenOnline() {
  late final StreamSubscription<bool> subscription;
  subscription =
      NetworkConnectivityService.instance.connectionStatusStream.listen((
    isOnline,
  ) async {
    if (!isOnline) return;
    if (Supabase.instance.client.auth.currentSession == null) {
      await subscription.cancel();
      return;
    }

    await ReadmeAuthBridge.ensureSignedIn(
      force: !ReadmeAuthBridge.readmeSessionMatchesHost(),
    );
    await subscription.cancel();
  });
}

/// Keeps the embedded ReadMe Supabase session in sync with Kanpur auth.
void _listenForReadmeAuthBridge() {
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.signedIn) {
      unawaited(ReadmeAuthBridge.ensureSignedIn(force: true));
    } else if (data.event == AuthChangeEvent.signedOut) {
      unawaited(ReadmeAuthBridge.signOut());
    }
  });
}
