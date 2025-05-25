import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkUtils {
  static Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      final payload = {'username': username, 'password': password};
      print('Login request payload: ${jsonEncode(payload)}');
      final response = await http.post(
        Uri.parse('https://wega.test.simetrix.ch/backend/api/v3/auth/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      print('Login response: ${response.body}');
      final data = jsonDecode(response.body);
      if (data['message'] == 'Authentication successful') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['result'] ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }
}
