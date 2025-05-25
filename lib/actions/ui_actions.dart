import 'package:flutter/material.dart';
import 'base_action.dart';

class ShowMessageAction implements BaseAction {
  @override
  Future<void> execute(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final message = actionConfig['message'] as String? ?? 'No message provided';
    final messageType = actionConfig['messageType'] as String? ?? 'info';

    Color backgroundColor;
    switch (messageType) {
      case 'success':
        backgroundColor = Colors.green;
        break;
      case 'error':
        backgroundColor = Colors.red;
        break;
      case 'warning':
        backgroundColor = Colors.orange;
        break;
      case 'info':
      default:
        backgroundColor = Colors.blue;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class ShowDialogAction implements BaseAction {
  @override
  Future<void> execute(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  ) async {
    final title = actionConfig['title'] as String? ?? 'Dialog';
    final content = actionConfig['content'] as String? ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content.isNotEmpty ? Text(content) : null,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
