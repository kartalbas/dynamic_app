import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networking/network_utils.dart';
import 'base_action.dart';

class LoginAction implements BaseAction {
  @override
  Future<void> execute(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final username = controllers['username']?.text ?? '';
    final password = controllers['password']?.text ?? '';

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    try {
      final payload = {'username': username, 'password': password};
      print('Login request payload: ${payload}');

      final response = await NetworkUtils.makeRequest('login', body: payload);

      print('Login response: $response');

      if (response != null &&
          response['message'] == 'Authentication successful') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', response['result'] ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }
}
