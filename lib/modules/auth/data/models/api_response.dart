/// Standard API Response wrapper for all REST API calls
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? statusCode;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.error,
  });

  /// Successful response with data
  factory ApiResponse.success(T data) {
    return ApiResponse(success: true, data: data, statusCode: '200');
  }

  /// Error response with message
  factory ApiResponse.error({
    required String message,
    String statusCode = '500',
    dynamic error,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  /// Loading state indicator
  factory ApiResponse.loading() {
    return ApiResponse(
      success: false,
      message: 'Loading...',
      statusCode: '100',
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;
  bool get isLoading => statusCode == '100';

  @override
  String toString() =>
      'ApiResponse(success: $success, statusCode: $statusCode, message: $message)';
}
