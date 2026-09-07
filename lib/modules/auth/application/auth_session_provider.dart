import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Emits whenever Supabase auth changes (sign-in, sign-out, token refresh).
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

/// Current signed-in Kanpur user id. Updates on sign-in, sign-out, and user switch.
final authUserIdProvider = StreamProvider<String?>((ref) async* {
  yield Supabase.instance.client.auth.currentUser?.id;

  await for (final authState in Supabase.instance.client.auth.onAuthStateChange) {
    switch (authState.event) {
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.signedOut:
      case AuthChangeEvent.userUpdated:
      case AuthChangeEvent.initialSession:
        yield authState.session?.user.id;
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.passwordRecovery:
      case AuthChangeEvent.mfaChallengeVerified:
      // ignore: deprecated_member_use
      case AuthChangeEvent.userDeleted:
        break;
    }
  }
});
