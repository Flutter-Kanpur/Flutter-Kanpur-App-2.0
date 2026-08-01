enum LinkKind { github, linkedin, website }

enum LinkStatus { empty, valid, invalid }

LinkStatus validateLink(String raw, LinkKind kind) {
  final text = raw.trim();
  if (text.isEmpty) return LinkStatus.empty;

  // Accept "github.com/user" without scheme
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
