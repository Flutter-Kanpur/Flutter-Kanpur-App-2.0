class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? fullName;
  final String? username;
  final String? photoUrl;
  final String? bio;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? websiteUrl;
  final int yearsOfExperience;
  final String status;
  final String createdAt;
  final String? updatedAt;
  final String? lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.fullName,
    this.username,
    this.photoUrl,
    this.bio,
    this.githubUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.yearsOfExperience = 0,
    this.status = 'active',
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  /// Create UserModel from Supabase JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      photoUrl: json['photo_url'] as String?,
      bio: json['bio'] as String?,
      githubUrl: json['github_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      websiteUrl: json['website_url'] as String?,
      yearsOfExperience: (json['years_of_experience'] as int?) ?? 0,
      status: (json['status'] as String?) ?? 'active',
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
    );
  }

  /// Convert UserModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'full_name': fullName,
      'username': username,
      'photo_url': photoUrl,
      'bio': bio,
      'github_url': githubUrl,
      'linkedin_url': linkedinUrl,
      'website_url': websiteUrl,
      'years_of_experience': yearsOfExperience,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_login_at': lastLoginAt,
    };
  }

  /// Create a copy with optional replacements
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? fullName,
    String? username,
    String? photoUrl,
    String? bio,
    String? githubUrl,
    String? linkedinUrl,
    String? websiteUrl,
    int? yearsOfExperience,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  String toString() => 'UserModel(uid: $uid, email: $email, displayName: $displayName)';
}
