/// Today's featured problem. In a real API this is presumably keyed by date
/// (one problem assigned per day), not something the client picks.
class DailyProblem {
  const DailyProblem({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

/// Aggregate streak/progress stats a backend would compute server-side
/// (from the user's solve history), not something derivable on-device.
class ProblemStreakProgress {
  const ProblemStreakProgress({
    required this.currentStreakDays,
    required this.totalProblemsSolved,
    required this.currentLevel,
    required this.currentLevelName,
    required this.levelProgress,
    required this.challengeDaysCompleted,
    required this.challengeDaysGoal,
  });

  final int currentStreakDays;
  final int totalProblemsSolved;

  /// Which level the user is currently on (e.g. matches the `level` shown by
  /// the ProblemOfDaySection summary widget elsewhere in the profile module).
  final int currentLevel;

  /// The level's display name, e.g. "Consistent Solver" (shown as "Level 2 —
  /// Consistent Solver" in the Details card).
  final String currentLevelName;

  /// Progress toward the *next* level, 0.0–1.0.
  final double levelProgress;

  /// Progress within the current day-streak challenge, e.g. 4 of 30 days.
  final int challengeDaysCompleted;
  final int challengeDaysGoal;
}

class ProblemOfDayDetails {
  const ProblemOfDayDetails({
    required this.frequency,
    required this.difficulty,
    required this.startedOn,
  });

  /// e.g. "Daily" / "Weekly" — how often a new problem is assigned.
  final String frequency;

  /// e.g. "Beginner" / "Intermediate" / "Advanced".
  final String difficulty;

  /// When the user started this challenge.
  final DateTime startedOn;
}

/// A single earned/lockable badge. [iconUrl] is expected to come from the
/// backend (a real image URL) — empty for now since there's no badge-art
/// pipeline yet; the UI falls back to a generic placeholder icon until then.
class ProblemBadge {
  const ProblemBadge({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.isUnlocked,
  });

  final String id;
  final String name;
  final String iconUrl;
  final bool isUnlocked;
}

/// The full payload this screen needs — shaped like what a single
/// `/problem-of-the-day` endpoint would plausibly return, rather than a flat
/// bag of display strings copied verbatim from the design.
class ProblemOfDayOverview {
  const ProblemOfDayOverview({
    required this.problem,
    required this.progress,
    required this.details,
    required this.badges,
    required this.nextBadgeStreakThreshold,
  });

  final DailyProblem problem;
  final ProblemStreakProgress progress;
  final ProblemOfDayDetails details;
  final List<ProblemBadge> badges;

  /// Streak-days needed to unlock the next badge, e.g. 7.
  final int nextBadgeStreakThreshold;
}
