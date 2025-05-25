import 'package:flutter/material.dart';
import 'base_widget.dart';
import '../actions/action_registry.dart';

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
            final actionType = action['type'];

            if (actionType != null) {
              await ActionRegistry.executeAction(
                actionType,
                context,
                action,
                controllers,
                boolControllers,
              );
              return;
            }
          }

          // Fallback for actions without type
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Action: ${node['action']?['type'] ?? 'unknown'}'),
            ),
          );
        },
        child: Text(node['text'] ?? 'Button'),
      ),
    );
  }
}
