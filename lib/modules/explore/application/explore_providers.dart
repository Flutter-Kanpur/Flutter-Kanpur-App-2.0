import 'package:flutter_knp_mobile_app_v2/modules/explore/data/explore_local_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/suggested_job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// heroBannerSlidesProvider/coreTeamMembersProvider are still synchronous
// plain Providers - there is nothing to await for that sample data yet.
// Community projects and suggested jobs simulate an async fetch (see
// ExploreLocalDataSource), so those use AsyncNotifierProvider - the same
// pattern the real `communityProjectsProvider` uses - with loading/error/data
// handled via `.when()` in their preview sections.

final heroBannerSlidesProvider = Provider<List<Map<String, String?>>>(
  (ref) => ExploreLocalDataSource.fetchHeroBannerSlides(),
);

final exploreCommunityProjectPreviewsProvider =
    AsyncNotifierProvider<
      ExploreCommunityProjectPreviewsNotifier,
      List<CommunityProjectPreview>
    >(ExploreCommunityProjectPreviewsNotifier.new);

class ExploreCommunityProjectPreviewsNotifier
    extends AsyncNotifier<List<CommunityProjectPreview>> {
  @override
  Future<List<CommunityProjectPreview>> build() =>
      ExploreLocalDataSource.fetchCommunityProjectPreviews();
}

final coreTeamMembersProvider = Provider<List<CoreTeamMember>>(
  (ref) => ExploreLocalDataSource.fetchCoreTeamMembers(),
);

final suggestedJobsProvider =
    AsyncNotifierProvider<ExploreSuggestedJobsNotifier, List<SuggestedJob>>(
      ExploreSuggestedJobsNotifier.new,
    );

class ExploreSuggestedJobsNotifier extends AsyncNotifier<List<SuggestedJob>> {
  @override
  Future<List<SuggestedJob>> build() =>
      ExploreLocalDataSource.fetchSuggestedJobs();
}
