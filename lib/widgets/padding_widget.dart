import 'package:flutter/material.dart';
import 'base_widget.dart';

class PaddingWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    final paddingValue = node['padding'];
    EdgeInsets padding;
    if (paddingValue is num) {
      padding = EdgeInsets.all(paddingValue.toDouble());
    } else if (paddingValue is Map<String, dynamic>) {
      padding = EdgeInsets.only(
        left: (paddingValue['left'] ?? 0).toDouble(),
        top: (paddingValue['top'] ?? 0).toDouble(),
        right: (paddingValue['right'] ?? 0).toDouble(),
        bottom: (paddingValue['bottom'] ?? 0).toDouble(),
      );
    } else {
      padding = EdgeInsets.zero;
    }
    return Padding(
      padding: padding,
      child: node['child'] != null ? buildWidget(node['child'], context) : null,
    );
  }
}
