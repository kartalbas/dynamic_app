import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networking/network_utils.dart';
import 'base_action.dart';
import 'navigation_action.dart';
import 'ui_actions.dart';

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
      print('Login request payload: $payload');

      final response = await NetworkUtils.makeRequest('login', body: payload);
      print('Login response: $response');

      if (response != null &&
          response['message'] == 'Authentication successful') {
        // Save JWT token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', response['result'] ?? '');
        
        print('Login successful - executing onSuccess action');
        
        // Execute onSuccess action from configuration
        final onSuccess = actionConfig['onSuccess'];
        if (onSuccess != null) {
          print('Found onSuccess config: $onSuccess');
          await _executeCallbackAction(context, onSuccess, controllers, boolControllers);
        } else {
          // Fallback message if no onSuccess action is configured
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Login successful')),
          );
        }
      } else {
        print('Login failed - executing onFailure action');
        
        // Execute onFailure action from configuration
        final onFailure = actionConfig['onFailure'];
        if (onFailure != null) {
          // Add the error message to the failure action config
          final failureConfig = Map<String, dynamic>.from(onFailure);
          failureConfig['message'] = response != null ? response['message'] ?? 'Login failed' : 'Login failed';
          print('Found onFailure config: $failureConfig');
          await _executeCallbackAction(context, failureConfig, controllers, boolControllers);
        } else {
          // Fallback message if no onFailure action is configured
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response != null ? response['message'] ?? 'Login failed' : 'Login failed')),
          );
        }
      }
    } catch (e) {
      print('Login error - executing onFailure action: $e');
      
      // Execute onFailure action from configuration
      final onFailure = actionConfig['onFailure'];
      if (onFailure != null) {
        final failureConfig = Map<String, dynamic>.from(onFailure);
        failureConfig['message'] = 'Login failed: $e';
        await _executeCallbackAction(context, failureConfig, controllers, boolControllers);
      } else {
        // Fallback message if no onFailure action is configured
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  Future<void> _executeCallbackAction(
    BuildContext context,
    Map<String, dynamic> callbackConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final actionType = callbackConfig['type'] as String?;
    
    if (actionType == null) {
      print('No action type specified in callback config');
      return;
    }

    print('Executing callback action: $actionType with config: $callbackConfig');

    // Handle specific action types directly to avoid circular imports
    switch (actionType) {
      case 'navigate':
        await NavigationAction().execute(context, callbackConfig, controllers, boolControllers);
        break;
      case 'showMessage':
        await ShowMessageAction().execute(context, callbackConfig, controllers, boolControllers);
        break;
      case 'showDialog':
        await ShowDialogAction().execute(context, callbackConfig, controllers, boolControllers);
        break;
      default:
        print('Unknown callback action type: $actionType');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown callback action: $actionType')),
        );
        break;
    }
  }
}
