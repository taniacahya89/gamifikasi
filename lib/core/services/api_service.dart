import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../features/auth/models/user_model.dart';
import '../../features/mission/models/mission_model.dart';

class ApiService {
  // Base URL backend - local IP untuk testing di device fisik
  static const String baseUrl = 'http://192.168.18.171:3000/api';
  
  final http.Client _client = http.Client();

  // Headers dasar untuk semua request
  Map<String, String> getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Auth Services
  // =============

  /// Login user ke backend
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  /// Register user baru ke backend
  Future<Map<String, dynamic>> register(String fullName, String email, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: getHeaders(),
      body: jsonEncode({
        'username': fullName,
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  /// Get user profile dari backend
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: getHeaders(token: token),
    );

    return _handleResponse(response);
  }

  /// Update user profile di backend
  Future<Map<String, dynamic>> updateProfile(String token, Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: getHeaders(token: token),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  // Mission Services
  // ================

  /// Get semua missions dari backend
  Future<Map<String, dynamic>> getAllMissions(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/missions'),
      headers: getHeaders(token: token),
    );

    return _handleResponse(response);
  }

  /// Get mission by ID
  Future<Map<String, dynamic>> getMissionById(String token, String missionId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/missions/$missionId'),
      headers: getHeaders(token: token),
    );

    return _handleResponse(response);
  }

  /// Get missions by category
  Future<Map<String, dynamic>> getMissionsByCategory(String token, String category) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/missions/category/$category'),
      headers: getHeaders(token: token),
    );

    return _handleResponse(response);
  }

  /// Create mission baru
  Future<Map<String, dynamic>> createMission(String token, Map<String, dynamic> missionData) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/missions'),
      headers: getHeaders(token: token),
      body: jsonEncode(missionData),
    );

    return _handleResponse(response);
  }

  /// Delete mission
  Future<Map<String, dynamic>> deleteMission(String token, String missionId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/missions/$missionId'),
      headers: getHeaders(token: token),
    );

    return _handleResponse(response);
  }

  /// Start mission (untuk user)
  Future<Map<String, dynamic>> startMission(String token, String missionId) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/missions/start'),
      headers: getHeaders(token: token),
      body: jsonEncode({
        'missionId': missionId,
      }),
    );

    return _handleResponse(response);
  }

  /// Complete mission (untuk user)
  Future<Map<String, dynamic>> completeMission(String token, String missionId) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/missions/complete'),
      headers: getHeaders(token: token),
      body: jsonEncode({
        'missionId': missionId,
      }),
    );

    return _handleResponse(response);
  }

  /// Get user progress dari backend
  Future<Map<String, dynamic>> getUserProgress(String token) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/missions/user/progress'),
      headers: getHeaders(token: token),
    );

    return _handleResponse(response);
  }

  // Helper Methods
  // ==============

  /// Handle response dari backend
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    // Add timeout handling
    if (response == null) {
      return {
        'success': false,
        'error': 'Request timed out',
        'status': 408,
        'data': null,
      };
    }

    try {
      final jsonResponse = jsonDecode(body);

      if (statusCode >= 200 && statusCode < 300) {
        // Success response
        return {
          'success': true,
          'data': jsonResponse,
          'status': statusCode,
        };
      } else {
        // Error response
        return {
          'success': false,
          'error': jsonResponse['message'] ?? 'An error occurred',
          'status': statusCode,
          'data': jsonResponse,
        };
      }
    } catch (e) {
      // JSON parsing error
      return {
        'success': false,
        'error': 'Failed to parse response: $e',
        'status': statusCode,
        'data': body,
      };
    }
  }

  /// Close HTTP client
  void dispose() {
    _client.close();
  }
}