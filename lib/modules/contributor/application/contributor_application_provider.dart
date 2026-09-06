import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/contributor_application_draft.dart';

final contributorApplicationDraftProvider =
    NotifierProvider<ContributorApplicationDraftNotifier,
        ContributorApplicationDraft?>(ContributorApplicationDraftNotifier.new);

class ContributorApplicationDraftNotifier
    extends Notifier<ContributorApplicationDraft?> {
  @override
  ContributorApplicationDraft? build() => null;

  void save(ContributorApplicationDraft draft) => state = draft;

  void clear() => state = null;
}
