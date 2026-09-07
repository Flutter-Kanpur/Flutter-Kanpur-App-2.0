import 'package:supabase_flutter/supabase_flutter.dart';

class SupportService {
  SupportService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _functionName = 'send-support-email';

  Future<bool> sendContactMessage({
    required String subject,
    required String message,
    required String fullName,
    required String email,
  }) {
    return _invoke({
      'type': 'contact',
      'subject': subject,
      'message': message,
      'fullName': fullName,
      'email': email,
      'userId': _client.auth.currentUser?.id,
    });
  }

 Future<bool> sendIssueReport({
  required String issueType,
  required String description,
  String? attachmentBase64,
  String? attachmentFilename,
  String? attachmentContentType,
}) {
  return _invoke({
    'type': 'report_issue',
    'issueType': issueType,
    'description': description,
    if (attachmentBase64 != null) 'attachmentBase64': attachmentBase64,
    if (attachmentFilename != null) 'attachmentFilename': attachmentFilename,
    if (attachmentContentType != null)
      'attachmentContentType': attachmentContentType,
    'userId': _client.auth.currentUser?.id,
    'email': _client.auth.currentUser?.email,
  });
}

  Future<bool> _invoke(Map<String, dynamic> body) async {
    final res = await _client.functions.invoke(_functionName, body: body);
    return res.status >= 200 && res.status < 300;
  }
}