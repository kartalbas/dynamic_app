import 'package:flutter/material.dart';
import 'base_widget.dart';

class AppBarWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return AppBar(
      title: node['title'] != null ? buildWidget(node['title'], context) : null,
    );
  }
}
