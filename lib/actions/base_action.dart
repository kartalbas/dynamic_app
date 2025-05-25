import 'package:flutter/material.dart';

abstract class BaseAction {
  Future<void> execute(
    BuildContext context,
    Map<String, dynamic> actionConfig,
    Map<String, TextEditingController> controllers,
    Map<String, bool> boolControllers,
  );
}
