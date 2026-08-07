/// Reusable `TextFormField` validators.
///
/// Each returns null when the value is acceptable, or a user-facing message.
class FormValidators {
  const FormValidators._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required.';
    return null;
  }

  static String? minLength(
    String? value, {
    required int min,
    String field = 'This field',
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$field is required.';
    if (text.length < min) {
      return '$field must be at least $min characters.';
    }
    return null;
  }

  static String? maxLength(
    String? value, {
    required int max,
    String field = 'This field',
  }) {
    if ((value?.trim().length ?? 0) > max) {
      return '$field must be $max characters or fewer.';
    }
    return null;
  }

  /// Validates a web URL. Pass `optional: true` to allow an empty value.
  static String? url(
    String? value, {
    bool optional = false,
    String field = 'Link',
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return optional ? null : '$field is required.';
    }

    final uri = Uri.tryParse(text);
    if (uri == null ||
        !uri.hasScheme ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        (uri.host).isEmpty ||
        !uri.host.contains('.')) {
      return 'Enter a valid link starting with https://';
    }
    return null;
  }

  /// URL that must additionally be hosted on [host] (or a subdomain of it).
  static String? urlOnHost(
    String? value, {
    required String host,
    bool optional = false,
    String field = 'Link',
  }) {
    final base = url(value, optional: optional, field: field);
    if (base != null) return base;

    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final parsed = Uri.parse(text).host.toLowerCase();
    if (parsed != host && !parsed.endsWith('.$host')) {
      return '$field must be a $host link.';
    }
    return null;
  }
}
