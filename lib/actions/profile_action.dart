import 'package:flutter/material.dart';
import '../networking/network_utils.dart';
import 'base_action.dart';

class ProfileAction implements BaseAction {
  @override
  Future<void> execute(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    try {
      final response = await NetworkUtils.makeRequest('profile');

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile loaded: ${response['name'] ?? 'User'}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load profile')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile action failed: $e')));
    }
  }
}
