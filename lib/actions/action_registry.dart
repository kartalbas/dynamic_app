import 'package:flutter/material.dart';
import 'base_action.dart';
import 'login_action.dart';

class ActionRegistry {
  static final Map<String, BaseAction> _actions = {'login': LoginAction()};

  static Future<void> executeAction(
    String actionType,
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final action = _actions[actionType];
    if (action != null) {
      await action.execute(context, actionConfig, controllers, boolControllers);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unknown action: $actionType')));
    }
  }

  static void registerAction(String type, BaseAction action) {
    _actions[type] = action;
  }

  static bool hasAction(String type) {
    return _actions.containsKey(type);
  }
}
