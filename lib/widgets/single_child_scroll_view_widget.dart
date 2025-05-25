import 'package:flutter/material.dart';
import 'base_widget.dart';

class SingleChildScrollViewWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return SingleChildScrollView(
      child: node['child'] != null ? buildWidget(node['child'], context) : null,
    );
  }
}
