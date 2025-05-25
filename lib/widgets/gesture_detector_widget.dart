import 'package:flutter/material.dart';
import 'base_widget.dart';

class GestureDetectorWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return GestureDetector(
      onTap: () {
        if (node['onTap'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('onTap: ${node['onTap']['type']}')),
          );
        }
      },
      child: node['child'] != null ? buildWidget(node['child'], context) : null,
    );
  }
}
