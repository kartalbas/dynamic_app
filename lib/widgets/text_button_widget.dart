import 'package:flutter/material.dart';
import 'base_widget.dart';

class TextButtonWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return TextButton(
      onPressed: () {
        if (node['onPressed'] != null) {
          final onPressed = node['onPressed'];
          if (onPressed['type'] == 'navigate' && onPressed['route'] != null) {
            Navigator.of(context).pushNamed(onPressed['route']);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('onPressed: ${onPressed['type']}')),
          );
        }
      },
      child: Text(node['text'] ?? 'TextButton'),
    );
  }
}
