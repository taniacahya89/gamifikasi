import 'package:http/http.dart' as http;

class BaseClient {
  static const String _baseUrl = 'http://192.168.18.171:3000'; // IP laptop untuk testing di iPhone
  static const int _timeout = 30; // Detik

  static http.Client get client {
    return http.Client();
  }

  static Uri getUri(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...getHeaders(),
      'Authorization': 'Bearer $token',
    };
  }
}