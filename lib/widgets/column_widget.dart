import 'package:flutter/material.dart';
import 'base_widget.dart';

class ColumnWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: node['spacing'] != null ? node['spacing'].toDouble() : 0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          node['mainAxisAlignment'] == 'center'
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
      children:
          (node['children'] as List<dynamic>? ?? [])
              .map((child) => buildWidget(child, context))
              .whereType<Widget>()
              .toList(),
    );
  }
}
