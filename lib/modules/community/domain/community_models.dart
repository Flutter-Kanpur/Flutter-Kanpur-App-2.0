enum CommunityPostType { announcement, discussion, question, project }

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.title,
    required this.body,
    required this.type,
    required this.tags,
    required this.replyCount,
    required this.likeCount,
    required this.createdLabel,
  });

  final String id;
  final String authorName;
  final String authorRole;
  final String title;
  final String body;
  final CommunityPostType type;
  final List<String> tags;
  final int replyCount;
  final int likeCount;
  final String createdLabel;
}

class CommunityMember {
  const CommunityMember({
    required this.name,
    required this.role,
    required this.skills,
    required this.status,
    this.photoUrl,
  });

  final String name;
  final String role;
  final List<String> skills;
  final String status;
  final String? photoUrl;

  factory CommunityMember.fromMap(Map<String, dynamic> map) {
    final user = map['member'] as Map<String, dynamic>?;
    final skillsList = (user?['user_skills'] as List<dynamic>?) ?? [];
    return CommunityMember(
      name: user?['display_name'] as String? ??
          user?['username'] as String? ??
          'Anonymous',
      role: map['role'] as String? ?? 'member',
      skills: skillsList
          .map((s) => (s as Map)['skill_name'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList(),
      status: map['membership_status'] as String? ?? 'active',
      photoUrl: user?['photo_url'] as String?,
    );
  }
}

class CommunityProject {
  const CommunityProject({
    this.id = '',
    required this.title,
    required this.summary,
    required this.status,
    required this.techStack,
    this.ownerName,
    this.githubUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String status;
  final List<String> techStack;
  final String? ownerName;
  final String? githubUrl;

  factory CommunityProject.fromMap(Map<String, dynamic> map) {
    final owner = map['owner'] as Map<String, dynamic>?;
    final techList = (map['project_tech_stack'] as List<dynamic>?) ?? [];
    return CommunityProject(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      status: _formatStatus(map['status'] as String? ?? 'draft'),
      techStack: techList
          .map((t) => (t as Map)['tech_name'] as String? ?? '')
          .where((t) => t.isNotEmpty)
          .toList(),
      ownerName: owner?['display_name'] as String? ?? owner?['username'] as String?,
      githubUrl: map['github_url'] as String?,
    );
  }

  static String _formatStatus(String raw) {
    switch (raw) {
      case 'active':
        return 'Active';
      case 'pending_review':
        return 'In Review';
      case 'completed':
        return 'Completed';
      default:
        return 'Planned';
    }
  }
}

class CommunityQuestion {
  const CommunityQuestion({
    required this.id,
    required this.title,
    required this.body,
    required this.tag,
    required this.answerCount,
    required this.status,
    required this.authorName,
    required this.createdLabel,
    this.authorPhotoUrl,
  });

  final String id;
  final String title;
  final String body;
  final String tag;
  final int answerCount;
  final String status;
  final String authorName;
  final String createdLabel;
  final String? authorPhotoUrl;

  factory CommunityQuestion.fromMap(Map<String, dynamic> map) {
    final author = map['author'] as Map<String, dynamic>?;
    return CommunityQuestion(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      tag: '',
      answerCount: map['answer_count'] as int? ?? 0,
      status: map['status'] as String? ?? 'open',
      authorName: author?['display_name'] as String? ??
          author?['username'] as String? ??
          'Anonymous',
      createdLabel: _timeAgo(map['created_at'] as String?),
      authorPhotoUrl: author?['photo_url'] as String?,
    );
  }

  static String _timeAgo(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

class CommunityReply {
  const CommunityReply({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoUrl,
    required this.createdLabel,
    required this.body,
    required this.likeCount,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String createdLabel;
  final String body;
  final int likeCount;
  final String createdAt;

  factory CommunityReply.fromMap(Map<String, dynamic> map) {
    final author = map['author'] as Map<String, dynamic>?;
    return CommunityReply(
      id: map['id'] as String? ?? '',
      authorId: author?['uid'] as String? ?? '',
      authorName: author?['display_name'] as String? ??
          author?['username'] as String? ??
          'Anonymous',
      authorPhotoUrl: author?['photo_url'] as String?,
      createdLabel: CommunityQuestion._timeAgo(map['created_at'] as String?),
      body: map['body'] as String? ?? '',
      likeCount: map['like_count'] as int? ?? 0,
      createdAt: map['created_at'] as String? ?? '',
    );
  }
}

class CommunityProjectSubmission {
  const CommunityProjectSubmission({
    required this.name,
    required this.description,
    required this.techStack,
    required this.links,
  });

  final String name;
  final String description;
  final List<String> techStack;
  final List<String> links;
}

class CommunityQuestionDraft {
  const CommunityQuestionDraft({
    required this.title,
    required this.details,
    required this.category,
    required this.tags,
    this.imageUrl,
  });

  final String title;
  final String details;
  final String category;
  final List<String> tags;
  final String? imageUrl;
}
