class OnboardingDraft {
  const OnboardingDraft({
    this.currentStep = 0,
    this.fullName = '',
    this.localPhotoPath,
    this.selectedRoles = const [],
    this.selectedSkills = const [],
    this.yearsOfExperience,
    this.githubUrl = '',
    this.linkedinUrl = '',
    this.websiteUrl = '',
    this.isSubmitting = false,
    this.error,
  });

  final int currentStep;
  final String fullName;
  final String? localPhotoPath;
  final List<String> selectedRoles;
  final List<String> selectedSkills;
  final int? yearsOfExperience;
  final String githubUrl;
  final String linkedinUrl;
  final String websiteUrl;
  final bool isSubmitting;
  final String? error;

  OnboardingDraft copyWith({
    int? currentStep,
    String? fullName,
    String? localPhotoPath,
    bool clearLocalPhotoPath = false,
    List<String>? selectedRoles,
    List<String>? selectedSkills,
    int? yearsOfExperience,
    bool clearYearsOfExperience = false,
    String? githubUrl,
    String? linkedinUrl,
    String? websiteUrl,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return OnboardingDraft(
      currentStep: currentStep ?? this.currentStep,
      fullName: fullName ?? this.fullName,
      localPhotoPath: clearLocalPhotoPath
          ? null
          : (localPhotoPath ?? this.localPhotoPath),
      selectedRoles: selectedRoles ?? this.selectedRoles,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      yearsOfExperience: clearYearsOfExperience
          ? null
          : (yearsOfExperience ?? this.yearsOfExperience),
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep,
      'fullName': fullName,
      'localPhotoPath': localPhotoPath,
      'selectedRoles': selectedRoles,
      'selectedSkills': selectedSkills,
      'yearsOfExperience': yearsOfExperience,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
      'websiteUrl': websiteUrl,
    };
  }

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) {
    return OnboardingDraft(
      currentStep: json['currentStep'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      localPhotoPath: json['localPhotoPath'] as String?,
      selectedRoles:
          (json['selectedRoles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      selectedSkills:
          (json['selectedSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      yearsOfExperience: json['yearsOfExperience'] as int?,
      githubUrl: json['githubUrl'] as String? ?? '',
      linkedinUrl: json['linkedinUrl'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
    );
  }
}
