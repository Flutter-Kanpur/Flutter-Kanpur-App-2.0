import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_session_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/data/repositories/leaderboard_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => LeaderboardRepository(),
);

/// Latest leaderboard. `autoDispose` so reopening shows a newly published
/// snapshot; no automatic retry - the error view has "Try again".
final leaderboardProvider = FutureProvider.autoDispose<Leaderboard>(
  (ref) => ref
      .watch(leaderboardRepositoryProvider)
      .fetchLatest(fallbackName: 'leaderboard.member'.tr()),
  retry: (_, _) => null,
);

/// Signed-in user's id, for highlighting their own leaderboard row.
final currentUserIdProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(authUserIdProvider.future),
);

/// Signed-in user's standing; refetches on account switch.
final myRankProvider = FutureProvider.autoDispose<MyRank>((ref) async {
  final userId = await ref.watch(authUserIdProvider.future);
  return ref.watch(leaderboardRepositoryProvider).fetchMyRank(userId);
}, retry: (_, _) => null);
