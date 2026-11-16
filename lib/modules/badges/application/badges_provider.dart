import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_session_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/data/repositories/badges_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final badgesRepositoryProvider = Provider<BadgesRepository>(
  (ref) => BadgesRepository(),
);

/// The signed-in user's badges grouped into categories for Your Badges.
///
/// `autoDispose` so reopening the screen picks up badges an admin assigned
/// meanwhile; watching [authUserIdProvider] refetches on account switch.
/// No automatic retry - the error view has a manual "Try again".
final myBadgeCategoriesProvider =
    FutureProvider.autoDispose<List<BadgeCategory>>((ref) async {
      final userId = await ref.watch(authUserIdProvider.future);
      final badges = await ref
          .watch(badgesRepositoryProvider)
          .fetchBadgesForUser(userId);
      return BadgeCategory.group(badges);
    }, retry: (_, _) => null);
