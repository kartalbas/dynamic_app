class NetworkConfig {
  static const int defaultTimeoutSeconds = 30;
  static const String defaultContentType = 'application/json';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': defaultContentType,
    'Accept': defaultContentType,
  };
}

enum HttpMethod { get, post, put, delete, patch }

class NetworkResponse<T> {
  final int statusCode;
  final T? data;
  final String? error;
  final Map<String, String>? headers;

  NetworkResponse({
    required this.statusCode,
    this.data,
    this.error,
    this.headers,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isError => !isSuccess;
}
