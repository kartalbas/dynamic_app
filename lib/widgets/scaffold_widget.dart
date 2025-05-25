import 'package:flutter/material.dart';
import 'base_widget.dart';

class ScaffoldWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    // Always wrap body in 16 padding as per original implementation
    Widget? bodyWidget =
        node['body'] != null ? buildWidget(node['body'], context) : null;
    bodyWidget = Padding(padding: const EdgeInsets.all(16), child: bodyWidget);

    return Scaffold(
      appBar:
          node['appBar'] != null
              ? buildWidget(node['appBar'], context) as PreferredSizeWidget?
              : null,
      body: bodyWidget,
    );
  }
}
