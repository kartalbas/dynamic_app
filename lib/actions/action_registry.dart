import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import 'base_action.dart';
import 'login_action.dart';
import 'navigation_action.dart';
import 'ui_actions.dart';

class ActionRegistry {
  static final Map<String, BaseAction> _actions = {
    'login': LoginAction(),
    'navigate': NavigationAction(),
    'showMessage': ShowMessageAction(),
    'showDialog': ShowDialogAction(),
    'loadProfile':
        LoginAction(), // Placeholder - will create specific ProfileLoadAction
  };

  static Future<void> executeAction(
    String actionType,
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    // Get action configuration from config manager
    final configuredAction = ConfigManager.getActionConfig(actionType);

    if (configuredAction != null) {
      // Merge provided config with configured action
      final mergedConfig = {...configuredAction, ...actionConfig};

      // Execute the action based on its configured type
      final implementationType = configuredAction['type'] as String?;

      if (implementationType != null) {
        await _executeConfiguredAction(
          implementationType,
          context,
          mergedConfig,
          controllers,
          boolControllers,
        );
        return;
      }
    }

    // Fallback to direct action execution
    final action = _actions[actionType];
    if (action != null) {
      await action.execute(context, actionConfig, controllers, boolControllers);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unknown action: $actionType')));
    }
  }

  static Future<void> _executeConfiguredAction(
    String actionType,
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    switch (actionType) {
      case 'navigation':
        await NavigationAction().execute(
          context,
          actionConfig,
          controllers,
          boolControllers,
        );
        break;
      case 'authentication':
        await _handleAuthenticationAction(
          context,
          actionConfig,
          controllers,
          boolControllers,
        );
        break;
      case 'data':
        await _handleDataAction(
          context,
          actionConfig,
          controllers,
          boolControllers,
        );
        break;
      case 'ui':
        await _handleUIAction(
          context,
          actionConfig,
          controllers,
          boolControllers,
        );
        break;
      default:
        final action = _actions[actionType];
        if (action != null) {
          await action.execute(
            context,
            actionConfig,
            controllers,
            boolControllers,
          );
        }
        break;
    }
  }

  static Future<void> _handleAuthenticationAction(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final endpoint = actionConfig['endpoint'] as String?;

    if (endpoint == 'login') {
      await LoginAction().execute(
        context,
        actionConfig,
        controllers,
        boolControllers,
      );

      // Handle success/failure actions
      // This would be expanded to check login result and execute onSuccess/onFailure
    }
  }

  static Future<void> _handleDataAction(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    // Handle data actions like loadProfile, updateProfile, etc.
    final endpoint = actionConfig['endpoint'] as String?;

    if (endpoint != null) {
      // This would use NetworkUtils to make the configured endpoint call
      // and then execute onSuccess/onFailure actions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data action for endpoint: $endpoint')),
      );
    }
  }

  static Future<void> _handleUIAction(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final actionName = actionConfig['description'] as String? ?? '';

    if (actionName.contains('message')) {
      await ShowMessageAction().execute(
        context,
        actionConfig,
        controllers,
        boolControllers,
      );
    } else if (actionName.contains('dialog')) {
      await ShowDialogAction().execute(
        context,
        actionConfig,
        controllers,
        boolControllers,
      );
    }
  }

  static void registerAction(String type, BaseAction action) {
    _actions[type] = action;
  }

  static bool hasAction(String type) {
    return _actions.containsKey(type) ||
        ConfigManager.getActionConfig(type) != null;
  }

  static List<String> getAvailableActions() {
    final configuredActions = ConfigManager.actions?.keys.toList() ?? [];
    final directActions = _actions.keys.toList();
    return {...configuredActions, ...directActions}.toList();
  }
}
