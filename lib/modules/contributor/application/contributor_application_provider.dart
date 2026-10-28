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

final myContributorMembershipProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  return ref.watch(contributorRepositoryProvider).fetchMyMembership();
});

final myContributorProjectsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(contributorRepositoryProvider).fetchMyProjects();
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
  final membershipAsync = ref.watch(myContributorMembershipProvider);

  if (appAsync.isLoading || membershipAsync.isLoading) {
    return const AsyncLoading();
  }

  // Active membership takes priority: user is already an approved contributor
  if (membershipAsync.value != null) {
    return const AsyncData(ContributorStatus.approved);
  }

  // If application fetch has an error and no membership exists, surface error
  if (appAsync.hasError) {
    return AsyncError(appAsync.error!, appAsync.stackTrace!);
  }

  final data = appAsync.value;
  if (data == null) return const AsyncData(ContributorStatus.notApplied);
  if (data['is_approved'] == true) return const AsyncData(ContributorStatus.approved);

  final status = (data['status'] as String? ?? 'pending').toLowerCase();
  switch (status) {
    case 'under_review':
      return const AsyncData(ContributorStatus.underReview);
    case 'rejected':
      return const AsyncData(ContributorStatus.rejected);
    case 'approved':
      return const AsyncData(ContributorStatus.approved);
    case 'pending':
    default:
      return const AsyncData(ContributorStatus.pending);
  }
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
    ref.invalidate(myContributorMembershipProvider);
    ref.invalidate(myContributorProjectsProvider);
    clear();
  }
}

