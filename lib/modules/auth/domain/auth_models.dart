class AuthResponse {
  final bool success;
  final String? userId;
  final String? email;
  final String? message;
  final String? errorCode;
  final String? errorMessage;

  AuthResponse({
    required this.success,
    this.userId,
    this.email,
    this.message,
    this.errorCode,
    this.errorMessage,
  });

  factory AuthResponse.success({
    required String userId,
    required String email,
    String? message,
  }) {
    return AuthResponse(
      success: true,
      userId: userId,
      email: email,
      message: message ?? 'Sign in successful',
    );
  }

  factory AuthResponse.error({
    required String errorCode,
    required String errorMessage,
  }) {
    return AuthResponse(
      success: false,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() =>
      'AuthResponse(success: $success, userId: $userId, email: $email, message: $message, errorCode: $errorCode, errorMessage: $errorMessage)';
}

class SignUpResponse {
  final bool success;
  final String? userId;
  final String? email;
  final String? message;
  final String? errorCode;
  final String? errorMessage;

  SignUpResponse({
    required this.success,
    this.userId,
    this.email,
    this.message,
    this.errorCode,
    this.errorMessage,
  });

  factory SignUpResponse.success({
    required String userId,
    required String email,
    String? message,
  }) {
    return SignUpResponse(
      success: true,
      userId: userId,
      email: email,
      message: message ?? 'Account created successfully',
    );
  }

  factory SignUpResponse.error({
    required String errorCode,
    required String errorMessage,
  }) {
    return SignUpResponse(
      success: false,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }
}
