import 'package:flutter/material.dart';
import 'base_widget.dart';
import '../utils/style_parser.dart';

class TextWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    return Text(
      node['data'] ?? '',
      style:
          node['style'] != null
              ? StyleParser.parseTextStyle(node['style'])
              : null,
    );
  }
}
