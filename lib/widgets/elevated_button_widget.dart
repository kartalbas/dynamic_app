import 'package:flutter/material.dart';
import 'base_widget.dart';
import '../utils/network_utils.dart';

class ElevatedButtonWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (node['action'] != null) {
            final action = node['action'];
            if (action['type'] == 'login') {
              final username = controllers['username']?.text ?? '';
              final password = controllers['password']?.text ?? '';
              await NetworkUtils.login(context, username, password);
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Action: ${node['action']['type']}')),
            );
          }
        },
        child: Text(node['text'] ?? 'Button'),
      ),
    );
  }
}
