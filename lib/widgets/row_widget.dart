import 'package:flutter/material.dart';
import 'base_widget.dart';

class RowWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children:
          (node['children'] as List<dynamic>? ?? [])
              .map((child) => buildWidget(child, context))
              .whereType<Widget>()
              .toList(),
    );
  }
}
