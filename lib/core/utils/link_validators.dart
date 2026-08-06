enum LinkKind { github, linkedin, website }

enum LinkStatus { empty, valid, invalid }

LinkStatus validateLink(String raw, LinkKind kind) {
  final text = raw.trim();
  if (text.isEmpty) return LinkStatus.empty;

  final withScheme = text.startsWith(RegExp(r'https?://'))
      ? text
      : 'https://$text';

  final uri = Uri.tryParse(withScheme);
  if (uri == null || uri.host.isEmpty) return LinkStatus.invalid;

  final host = uri.host.toLowerCase().replaceFirst('www.', '');

  switch (kind) {
    case LinkKind.github:
      return host == 'github.com' && uri.pathSegments.isNotEmpty
          ? LinkStatus.valid
          : LinkStatus.invalid;
    case LinkKind.linkedin:
      return host == 'linkedin.com' && uri.pathSegments.isNotEmpty
          ? LinkStatus.valid
          : LinkStatus.invalid;
    case LinkKind.website:
      return (uri.scheme == 'http' || uri.scheme == 'https')
          ? LinkStatus.valid
          : LinkStatus.invalid;
  }
}

const githubUrlPrefix = 'https://github.com/';
const linkedinUrlPrefix = 'https://www.linkedin.com/in/';

String buildGithubUrl(String username) {
  final u = username.trim().replaceAll(RegExp(r'^@'), '');
  if (u.isEmpty) return '';
  return '$githubUrlPrefix$u';
}

String buildLinkedinUrl(String username) {
  final u = username.trim().replaceAll(RegExp(r'^@'), '');
  if (u.isEmpty) return '';
  return '$linkedinUrlPrefix$u';
}

String usernameFromGithubUrl(String url) {
  final t = url.trim();
  if (t.isEmpty) return '';
  final uri = Uri.tryParse(t.startsWith('http') ? t : 'https://$t');
  if (uri == null || uri.pathSegments.isEmpty) return t;
  return uri.pathSegments.first;
}

String usernameFromLinkedinUrl(String url) {
  final t = url.trim();
  if (t.isEmpty) return '';
  final uri = Uri.tryParse(t.startsWith('http') ? t : 'https://$t');
  if (uri == null) return t;
  final parts = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (parts.length >= 2 && parts.first == 'in') return parts[1];
  return parts.isNotEmpty ? parts.last : t;
}

LinkStatus validateUsername(String username) {
  final u = username.trim().replaceAll(RegExp(r'^@'), '');
  if (u.isEmpty) return LinkStatus.empty;
  final ok = RegExp(r'^[a-zA-Z0-9-]{1,39}$').hasMatch(u);
  return ok ? LinkStatus.valid : LinkStatus.invalid;
}
