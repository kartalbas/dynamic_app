import 'package:flutter/material.dart';
import 'widgets/base_widget.dart';
import 'widgets/scaffold_widget.dart';
import 'widgets/text_widget.dart';
import 'widgets/elevated_button_widget.dart';
import 'widgets/text_button_widget.dart';
import 'widgets/column_widget.dart';
import 'widgets/row_widget.dart';
import 'widgets/padding_widget.dart';
import 'widgets/center_widget.dart';
import 'widgets/input_widgets.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/single_child_scroll_view_widget.dart';
import 'widgets/gesture_detector_widget.dart';

class JsonWidgetTreeInterpreter extends StatelessWidget {
  final Map<String, dynamic> json;
  JsonWidgetTreeInterpreter(this.json, {super.key});

  // Controllers for text fields and checkboxes
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _boolControllers = {};

  // Widget registry - now includes all widgets from the original implementation
  late final Map<String, BaseDynamicWidget> _widgetRegistry = {
    'Scaffold': ScaffoldWidget(),
    'AppBar': AppBarWidget(),
    'Column': ColumnWidget(),
    'Row': RowWidget(),
    'Text': TextWidget(),
    'TextField': TextFieldWidget(),
    'SingleChildScrollView': SingleChildScrollViewWidget(),
    'Checkbox': CheckboxWidget(),
    'ElevatedButton': ElevatedButtonWidget(),
    'TextButton': TextButtonWidget(),
    'GestureDetector': GestureDetectorWidget(),
    'Padding': PaddingWidget(),
    'Center': CenterWidget(),
  };

  @override
  Widget build(BuildContext context) {
    return _buildWidget(json, context);
  }

  Widget _buildWidget(Map<String, dynamic> node, BuildContext context) {
    final type = node['widget'];
    final widget = _widgetRegistry[type];

    if (widget != null) {
      return widget.build(
        node,
        context,
        _controllers,
        _boolControllers,
        _buildWidget,
      );
    }

    return const SizedBox.shrink();
  }
}
