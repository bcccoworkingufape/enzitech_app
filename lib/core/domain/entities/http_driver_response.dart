class HttpDriverResponse {
  final dynamic data;
  final int? statusCode;
  String? statusMessage;

  HttpDriverResponse({
    required this.data,
    required this.statusCode,
    this.statusMessage,
  });
}
