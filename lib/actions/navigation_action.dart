import 'package:flutter/material.dart';
import 'base_action.dart';

class NavigationAction implements BaseAction {
  @override
  Future<void> execute(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final target = actionConfig['target'] as String?;
    final replace = actionConfig['replace'] as bool? ?? false;

    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navigation target not specified')),
      );
      return;
    }

    if (replace) {
      Navigator.of(context).pushReplacementNamed(target);
    } else {
      Navigator.of(context).pushNamed(target);
    }
  }
}
