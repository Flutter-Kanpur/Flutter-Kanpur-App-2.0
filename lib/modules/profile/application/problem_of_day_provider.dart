import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'problem_of_day_state.dart';

// Temporary mock data - remove when backend is integrated
ProblemOfDayOverview _mockOverview() {
  return ProblemOfDayOverview(
    problem: const DailyProblem(
      id: 'potd-reverse-a-string',
      title: 'Reverse a String',
      description: 'Practice basic string manipulation using arrays or pointers.',
    ),
    progress: const ProblemStreakProgress(
      currentStreakDays: 6,
      totalProblemsSolved: 24,
      currentLevel: 2,
      currentLevelName: 'Consistent Solver',
      levelProgress: 0.40,
      challengeDaysCompleted: 4,
      challengeDaysGoal: 30,
    ),
    details: ProblemOfDayDetails(
      frequency: 'Daily',
      difficulty: 'Beginner',
      startedOn: DateTime.now().subtract(const Duration(days: 4)),
    ),
    badges: List.generate(
      5,
      (index) => ProblemBadge(
        id: 'badge-$index',
        name: 'Streak badge ${index + 1}',
        iconUrl: '', // placeholder — real icon URL comes from the backend
        isUnlocked: true,
      ),
    ),
    nextBadgeStreakThreshold: 7,
  );
}

final problemOfDayProvider = Provider<ProblemOfDayOverview>((ref) {
  return _mockOverview();
});
