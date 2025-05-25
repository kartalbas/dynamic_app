import 'package:flutter/material.dart';
import 'base_widget.dart';

class TextFieldWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    final controllerName = node['controller'];
    if (controllerName != null && !controllers.containsKey(controllerName)) {
      controllers[controllerName] = TextEditingController();
    }

    return TextField(
      controller: controllerName != null ? controllers[controllerName] : null,
      obscureText: node['obscureText'] == true,
      decoration: InputDecoration(
        hintText:
            node['decoration'] != null ? node['decoration']['hintText'] : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class CheckboxWidget implements BaseDynamicWidget {
  @override
  Widget build(
    Map<String, dynamic> node,
    BuildContext context,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
    Widget? Function(Map<String, dynamic>, BuildContext) buildWidget,
  ) {
    final controllerName = node['controller'];
    if (controllerName != null &&
        !boolControllers.containsKey(controllerName)) {
      boolControllers[controllerName] = false;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Checkbox(
          value:
              controllerName != null ? boolControllers[controllerName] : false,
          onChanged: (val) {
            if (controllerName != null) {
              setState(() {
                boolControllers[controllerName] = val ?? false;
              });
            }
          },
        );
      },
    );
  }
}
