/// A row from `public.notifications`.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.module,
    required this.title,
    required this.body,
    required this.createdLabel,
    required this.isRead,
  });

  final String id;
  final String module;
  final String title;
  final String body;
  final String createdLabel;
  final bool isRead;

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String? ?? '',
      module: map['module'] as String? ?? 'general',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      createdLabel: _timeAgo(map['created_at'] as String?),
      isRead: map['read_at'] != null,
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
    return '${diff.inDays}d ago';
  }
}
