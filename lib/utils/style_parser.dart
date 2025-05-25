import 'package:flutter/material.dart';

class StyleParser {
  static TextStyle? parseTextStyle(Map<String, dynamic>? style) {
    if (style == null) return null;
    return TextStyle(
      color: style['color'] != null ? parseColor(style['color']) : null,
      decoration:
          style['decoration'] == 'underline' ? TextDecoration.underline : null,
    );
  }

  static Color? parseColor(dynamic colorString) {
    if (colorString is String && colorString.startsWith('#')) {
      final hex = colorString.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }
    return null;
  }
}
