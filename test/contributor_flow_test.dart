import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/domain/contributor_application_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContributorApplicationDraft serialization', () {
    test('round-trips through Supabase map accurately', () {
      final draft = ContributorApplicationDraft(
        fullName: 'Angelica Singh',
        email: 'angie.work@gmail.com',
        currentRole: 'UI/UX Designer',
        contributionArea: 'Design System',
        skills: const ['Figma', 'UI/UX Designer', 'Flutter'],
        experienceLevel: '2 years',
        weeklyHours: '2-4 hours',
        whyContribute: 'I want to help build great mobile community experiences.',
        githubUrl: 'https://github.com/angelica-singh-04',
        websiteUrl: 'https://angelica.works',
        linkedinUrl: 'https://linkedin.com/angelica.works',
      );

      final map = draft.toSupabaseMap('user-123');
      expect(map['full_name'], 'Angelica Singh');
      expect(map['email'], 'angie.work@gmail.com');
      expect(map['job_role'], 'UI/UX Designer');
      expect(map['contribution_option'], 'Design System');
      expect(map['relevant_skills'], ['Figma', 'UI/UX Designer', 'Flutter']);
      expect(map['experience_level'], '2 years');
      expect(map['time_per_week'], '2-4 hours');
      expect(map['user_uid'], 'user-123');

      final reconstructed = ContributorApplicationDraft.fromSupabaseMap(map);
      expect(reconstructed.fullName, draft.fullName);
      expect(reconstructed.email, draft.email);
      expect(reconstructed.currentRole, draft.currentRole);
      expect(reconstructed.contributionArea, draft.contributionArea);
      expect(reconstructed.skills, draft.skills);
      expect(reconstructed.experienceLevel, draft.experienceLevel);
      expect(reconstructed.weeklyHours, draft.weeklyHours);
      expect(reconstructed.githubUrl, draft.githubUrl);
      expect(reconstructed.websiteUrl, draft.websiteUrl);
      expect(reconstructed.linkedinUrl, draft.linkedinUrl);
    });
  });

  group('contributorStatusProvider state resolution', () {
    test('resolves to approved when community membership is active', () async {
      final container = ProviderContainer(
        overrides: [
          myContributorMembershipProvider.overrideWith(
            (ref) async => {
              'role': 'contributor',
              'status': 'active',
              'joined_at': '2026-03-01T00:00:00Z',
            },
          ),
          myContributorApplicationProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);

      await container.read(myContributorMembershipProvider.future);
      await container.read(myContributorApplicationProvider.future);

      final asyncStatus = container.read(contributorStatusProvider);
      expect(asyncStatus.value, ContributorStatus.approved);
    });

    test('resolves to notApplied when no application and no membership exist', () async {
      final container = ProviderContainer(
        overrides: [
          myContributorMembershipProvider.overrideWith((ref) async => null),
          myContributorApplicationProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);

      await container.read(myContributorMembershipProvider.future);
      await container.read(myContributorApplicationProvider.future);

      final asyncStatus = container.read(contributorStatusProvider);
      expect(asyncStatus.value, ContributorStatus.notApplied);
    });

    test('resolves to underReview when application status is under_review', () async {
      final container = ProviderContainer(
        overrides: [
          myContributorMembershipProvider.overrideWith((ref) async => null),
          myContributorApplicationProvider.overrideWith(
            (ref) async => {'status': 'under_review', 'created_at': '2026-04-12T00:00:00Z'},
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(myContributorMembershipProvider.future);
      await container.read(myContributorApplicationProvider.future);

      final asyncStatus = container.read(contributorStatusProvider);
      expect(asyncStatus.value, ContributorStatus.underReview);
    });

    test('resolves to rejected when application status is rejected', () async {
      final container = ProviderContainer(
        overrides: [
          myContributorMembershipProvider.overrideWith((ref) async => null),
          myContributorApplicationProvider.overrideWith(
            (ref) async => {'status': 'rejected'},
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(myContributorMembershipProvider.future);
      await container.read(myContributorApplicationProvider.future);

      final asyncStatus = container.read(contributorStatusProvider);
      expect(asyncStatus.value, ContributorStatus.rejected);
    });

    test('resolves to pending when application status is pending', () async {
      final container = ProviderContainer(
        overrides: [
          myContributorMembershipProvider.overrideWith((ref) async => null),
          myContributorApplicationProvider.overrideWith(
            (ref) async => {'status': 'pending'},
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(myContributorMembershipProvider.future);
      await container.read(myContributorApplicationProvider.future);

      final asyncStatus = container.read(contributorStatusProvider);
      expect(asyncStatus.value, ContributorStatus.pending);
    });
  });
}
