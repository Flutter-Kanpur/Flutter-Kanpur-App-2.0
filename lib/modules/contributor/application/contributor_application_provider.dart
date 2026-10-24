import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/contributor_repository.dart';
import '../domain/contributor_application_draft.dart';

final contributorRepositoryProvider = Provider<ContributorRepository>((ref) {
  return ContributorRepository();
});

final myContributorApplicationProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  return ref.watch(contributorRepositoryProvider).fetchMyApplication();
});

enum ContributorStatus {
  notApplied,
  pending,
  underReview,
  approved,
  rejected,
}

final contributorStatusProvider =
    Provider<AsyncValue<ContributorStatus>>((ref) {
  final appAsync = ref.watch(myContributorApplicationProvider);
  return appAsync.whenData((data) {
    if (data == null) return ContributorStatus.notApplied;
    if (data['is_approved'] == true) return ContributorStatus.approved;

    final status = (data['status'] as String? ?? 'pending').toLowerCase();
    switch (status) {
      case 'under_review':
        return ContributorStatus.underReview;
      case 'rejected':
        return ContributorStatus.rejected;
      case 'approved':
        return ContributorStatus.approved;
      case 'pending':
      default:
        return ContributorStatus.pending;
    }
  });
});

final contributorApplicationDraftProvider =
    NotifierProvider<ContributorApplicationDraftNotifier,
        ContributorApplicationDraft?>(ContributorApplicationDraftNotifier.new);

class ContributorApplicationDraftNotifier
    extends Notifier<ContributorApplicationDraft?> {
  @override
  ContributorApplicationDraft? build() => null;

  void save(ContributorApplicationDraft draft) => state = draft;

  void clear() => state = null;

  /// Submits the current draft to Supabase, invalidates the application status cache, and clears the draft.
  Future<void> submit() async {
    final draft = state;
    if (draft == null) {
      throw Exception('No application draft available to submit.');
    }
    await ref.read(contributorRepositoryProvider).submitApplication(draft);
    ref.invalidate(myContributorApplicationProvider);
    clear();
  }
}

