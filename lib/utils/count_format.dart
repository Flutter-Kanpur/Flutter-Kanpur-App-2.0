/// Formats an engagement count the way the designs show it: `945`, `14.5k`,
/// `1.2m`. Trailing `.0` is dropped so 14000 reads as `14k`, not `14.0k`.
String formatCount(int value) {
  if (value < 0) return '0';
  if (value < 1000) return '$value';

  if (value < 1000000) {
    final k = value / 1000;
    return '${_trim(k)}k';
  }

  final m = value / 1000000;
  return '${_trim(m)}m';
}

String _trim(double value) {
  final oneDecimal = value.toStringAsFixed(1);
  return oneDecimal.endsWith('.0')
      ? oneDecimal.substring(0, oneDecimal.length - 2)
      : oneDecimal;
}
