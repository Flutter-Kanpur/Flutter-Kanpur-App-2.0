import 'package:flutter/widgets.dart';

import 'translate.dart';

/// One row of the years-of-experience picker.
///
/// [years] is the integer that lands in `users.years_of_experience`;
/// [translationKey] resolves the label shown to the user.
class YearsOfExperienceBucket {
  const YearsOfExperienceBucket(this.years, this.translationKey);

  final int years;
  final String translationKey;
}

/// Canonical buckets, ascending by [YearsOfExperienceBucket.years].
///
/// Single source of truth for both the Edit Profile dropdown and the
/// Role & Experience bottom sheet, which previously disagreed (5 options
/// vs a hardcoded 4-option list).
const List<YearsOfExperienceBucket> kYearsOfExperienceBuckets = [
  YearsOfExperienceBucket(0, 'editProfile.yearsOptions.year_0_1'),
  YearsOfExperienceBucket(1, 'editProfile.yearsOptions.year_1_2'),
  YearsOfExperienceBucket(2, 'editProfile.yearsOptions.year_2_3'),
  YearsOfExperienceBucket(3, 'editProfile.yearsOptions.year_3_5'),
  YearsOfExperienceBucket(5, 'editProfile.yearsOptions.year_5_plus'),
];

/// Localized labels in bucket order — feed straight into a dropdown.
List<String> yearsOfExperienceLabels(BuildContext context) => [
  for (final bucket in kYearsOfExperienceBuckets)
    translate(context, bucket.translationKey),
];

/// Stored int -> index into [kYearsOfExperienceBuckets].
///
/// Picks the highest bucket whose [YearsOfExperienceBucket.years] is `<= value`,
/// so a stored 4 lands in "3-5 years" and a stored 12 in "5+ years". Null and
/// negative values clamp to the first bucket.
int yearsOfExperienceIndexFor(int? value) {
  final resolved = value ?? 0;
  var index = 0;
  for (var i = 0; i < kYearsOfExperienceBuckets.length; i++) {
    if (kYearsOfExperienceBuckets[i].years <= resolved) index = i;
  }
  return index;
}

/// Stored int -> localized label.
String yearsOfExperienceLabelFor(BuildContext context, int? value) => translate(
  context,
  kYearsOfExperienceBuckets[yearsOfExperienceIndexFor(value)].translationKey,
);

/// Index into [kYearsOfExperienceBuckets] -> the int to store.
///
/// Callers hold the *index* rather than the label so a locale change between
/// picking and saving can never corrupt the round trip.
int yearsOfExperienceValueAt(int index) {
  final safe = index.clamp(0, kYearsOfExperienceBuckets.length - 1);
  return kYearsOfExperienceBuckets[safe].years;
}
