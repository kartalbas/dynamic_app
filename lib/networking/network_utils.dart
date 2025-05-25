import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtils {
  static Map<String, dynamic>? _endpoints;

  // Initialize with endpoints from config
  static void initialize(Map<String, dynamic> endpoints) {
    _endpoints = endpoints;
  }

  // Generic method to make HTTP requests
  static Future<Map<String, dynamic>?> makeRequest(
    String endpointName, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    if (_endpoints == null) {
      throw Exception('Network configuration not initialized');
    }

    final endpoint = _endpoints![endpointName];
    if (endpoint == null) {
      throw Exception('Endpoint "$endpointName" not found in configuration');
    }

    final url = endpoint['url'] as String;
    final method = (endpoint['method'] ?? 'GET').toString().toUpperCase();

    Uri uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final defaultHeaders = {'Content-Type': 'application/json'};
    final requestHeaders = {...defaultHeaders, ...?headers};

    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: requestHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {'statusCode': response.statusCode};
    } catch (e) {
      throw Exception('Network request failed: $e');
    }
  }

  // Helper method to get any endpoint URL
  static String? getEndpointUrl(String endpointName) {
    return _endpoints?[endpointName]?['url'];
  }

  // Helper method to get endpoint method
  static String? getEndpointMethod(String endpointName) {
    return _endpoints?[endpointName]?['method'];
  }

  // Check if endpoints are initialized
  static bool get isInitialized => _endpoints != null;
}
