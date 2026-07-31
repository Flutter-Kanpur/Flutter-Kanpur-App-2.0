import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ============================================================================
// CLASS: Onboarding Status
// ============================================================================
class OnboardingStatus {
  final bool isCompleted;
  final bool isLoading;
  final String? error;

  const OnboardingStatus({
    this.isCompleted = false,
    this.isLoading = false,
    this.error,
  });

  OnboardingStatus copyWith({
    bool? isCompleted,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingStatus(
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final onboardingStatusProvider = StateProvider<OnboardingStatus>(
  (ref) => const OnboardingStatus(),
);

final isOnboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(onboardingStatusProvider).isCompleted;
});

final completeOnboardingProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(onboardingStatusProvider.notifier).state = const OnboardingStatus(
      isCompleted: true,
    );
  };
});

final skipOnboardingProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(onboardingStatusProvider.notifier).state = const OnboardingStatus(
      isCompleted: true,
    );
  };
});
