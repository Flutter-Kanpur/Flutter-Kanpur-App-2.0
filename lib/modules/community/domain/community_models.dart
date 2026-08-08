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
      name:
          user?['display_name'] as String? ??
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
    this.liveUrl,
    this.coverImageUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String status;
  final List<String> techStack;
  final String? ownerName;
  final String? githubUrl;
  final String? liveUrl;
  final String? coverImageUrl;

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
      ownerName:
          owner?['display_name'] as String? ?? owner?['username'] as String?,
      githubUrl: map['github_url'] as String?,
      liveUrl: map['live_url'] as String?,
      coverImageUrl: map['cover_image_url'] as String?,
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
    required this.tags,
    required this.category,
    required this.answerCount,
    required this.likeCount,
    required this.saveCount,
    required this.status,
    required this.authorName,
    required this.createdLabel,
    this.authorPhotoUrl,
    this.imageUrl,
    this.isLiked = false,
    this.isSaved = false,
  });

  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final String category;
  final int answerCount;
  final int likeCount;
  final int saveCount;
  final String status;
  final String authorName;
  final String createdLabel;
  final String? authorPhotoUrl;
  final String? imageUrl;

  /// Whether the signed-in user has liked / bookmarked this question.
  /// Hydrated by the repository from `question_likes` / `question_saves`.
  final bool isLiked;
  final bool isSaved;

  /// First tag, or empty — kept for call sites that render a single chip.
  String get tag => tags.isEmpty ? '' : tags.first;

  CommunityQuestion copyWith({
    int? answerCount,
    int? likeCount,
    int? saveCount,
    bool? isLiked,
    bool? isSaved,
  }) {
    return CommunityQuestion(
      id: id,
      title: title,
      body: body,
      tags: tags,
      category: category,
      answerCount: answerCount ?? this.answerCount,
      likeCount: likeCount ?? this.likeCount,
      saveCount: saveCount ?? this.saveCount,
      status: status,
      authorName: authorName,
      createdLabel: createdLabel,
      authorPhotoUrl: authorPhotoUrl,
      imageUrl: imageUrl,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  factory CommunityQuestion.fromMap(
    Map<String, dynamic> map, {
    bool isLiked = false,
    bool isSaved = false,
  }) {
    final author = map['author'] as Map<String, dynamic>?;
    return CommunityQuestion(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      tags: _stringList(map['tags']),
      category: map['category'] as String? ?? 'general',
      answerCount: map['answer_count'] as int? ?? 0,
      likeCount: map['like_count'] as int? ?? 0,
      saveCount: map['save_count'] as int? ?? 0,
      status: map['status'] as String? ?? 'open',
      authorName:
          author?['display_name'] as String? ??
          author?['username'] as String? ??
          'Anonymous',
      createdLabel: _timeAgo(map['created_at'] as String?),
      authorPhotoUrl: author?['photo_url'] as String?,
      imageUrl: map['image_url'] as String?,
      isLiked: isLiked,
      isSaved: isSaved,
    );
  }

  /// `questions.tags` is a Postgres `TEXT[]`, which arrives as a List, but
  /// tolerate a comma-joined string too in case a row was written by hand.
  static List<String> _stringList(Object? raw) {
    if (raw is List) {
      return raw
          .map((t) => t?.toString().trim() ?? '')
          .where((t) => t.isNotEmpty)
          .toList();
    }
    if (raw is String) {
      return raw
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
    }
    return const [];
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
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
    required this.commentCount,
    required this.createdAt,
    this.isLiked = false,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String createdLabel;
  final String body;
  final int likeCount;
  final int commentCount;
  final String createdAt;

  /// Whether the signed-in user has liked this answer.
  final bool isLiked;

  CommunityReply copyWith({int? likeCount, bool? isLiked}) {
    return CommunityReply(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorPhotoUrl: authorPhotoUrl,
      createdLabel: createdLabel,
      body: body,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      createdAt: createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory CommunityReply.fromMap(
    Map<String, dynamic> map, {
    bool isLiked = false,
  }) {
    final author = map['author'] as Map<String, dynamic>?;
    return CommunityReply(
      id: map['id'] as String? ?? '',
      authorId: author?['uid'] as String? ?? '',
      authorName:
          author?['display_name'] as String? ??
          author?['username'] as String? ??
          'Anonymous',
      authorPhotoUrl: author?['photo_url'] as String?,
      createdLabel: CommunityQuestion._timeAgo(map['created_at'] as String?),
      body: map['body'] as String? ?? '',
      likeCount: map['like_count'] as int? ?? 0,
      commentCount: map['comment_count'] as int? ?? 0,
      createdAt: map['created_at'] as String? ?? '',
      isLiked: isLiked,
    );
  }
}

/// One page of questions plus whether the server has more behind it.
class CommunityQuestionPage {
  const CommunityQuestionPage({required this.items, required this.hasMore});

  final List<CommunityQuestion> items;
  final bool hasMore;
}

class CommunityProjectSubmission {
  const CommunityProjectSubmission({
    required this.name,
    required this.description,
    required this.techStack,
    required this.githubUrl,
    this.liveDemoUrl,
    this.screenshotUrl,
  });

  final String name;
  final String description;
  final List<String> techStack;
  final String githubUrl;
  final String? liveDemoUrl;
  final String? screenshotUrl;
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
