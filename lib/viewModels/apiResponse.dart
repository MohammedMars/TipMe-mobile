class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<dynamic> errors;
  final dynamic errorCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
    this.errorCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] ?? [],
      errorCode: json['errorCode'],
    );
  }
}