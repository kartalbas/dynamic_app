import 'package:flutter/material.dart';
import '../services/config_manager.dart';

class StyleParser {
  static TextStyle? parseTextStyle(dynamic style) {
    print('StyleParser: Parsing text style: $style');

    if (style == null) return null;

    // If it's a string, treat it as a style name from theme config
    if (style is String) {
      print('StyleParser: Looking up named style: $style');
      final styleConfig = ConfigManager.getTextStyle(style);
      if (styleConfig != null) {
        print('StyleParser: Found style config: $styleConfig');
        return _parseTextStyleFromConfig(styleConfig);
      }
      print('StyleParser: Named style "$style" not found');
      return null;
    }

    // If it's a map, parse it directly
    if (style is Map<String, dynamic>) {
      print('StyleParser: Parsing inline style: $style');
      return _parseTextStyleFromConfig(style);
    }

    return null;
  }

  static TextStyle _parseTextStyleFromConfig(Map<String, dynamic> style) {
    final color = parseColor(style['color']);
    final fontSize = (style['fontSize'] as num?)?.toDouble();
    final fontWeight = _parseFontWeight(style['fontWeight']);

    print(
      'StyleParser: Creating TextStyle - color: $color, fontSize: $fontSize, fontWeight: $fontWeight',
    );

    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration:
          style['decoration'] == 'underline' ? TextDecoration.underline : null,
    );
  }

  static FontWeight? _parseFontWeight(dynamic weight) {
    if (weight == null) return null;
    if (weight is String) {
      switch (weight) {
        case 'bold':
          return FontWeight.bold;
        case 'w100':
          return FontWeight.w100;
        case 'w200':
          return FontWeight.w200;
        case 'w300':
          return FontWeight.w300;
        case 'w400':
          return FontWeight.w400;
        case 'w500':
          return FontWeight.w500;
        case 'w600':
          return FontWeight.w600;
        case 'w700':
          return FontWeight.w700;
        case 'w800':
          return FontWeight.w800;
        case 'w900':
          return FontWeight.w900;
        case 'normal':
          return FontWeight.normal;
        default:
          return null;
      }
    }
    return null;
  }

  static Color? parseColor(dynamic colorValue) {
    print('StyleParser: Parsing color: $colorValue');

    if (colorValue == null) return null;

    if (colorValue is String) {
      // Check if it's a color palette reference
      if (!colorValue.startsWith('#')) {
        print('StyleParser: Looking up palette color: $colorValue');
        final paletteColor = ConfigManager.getColorFromPalette(colorValue);
        if (paletteColor != null) {
          colorValue = paletteColor;
          print('StyleParser: Found palette color: $paletteColor');
        }
      }

      // Parse hex color
      if (colorValue.startsWith('#')) {
        final hex = colorValue.replaceFirst('#', '');
        if (hex.length == 6) {
          final color = Color(int.parse('FF$hex', radix: 16));
          print('StyleParser: Parsed hex color: $colorValue -> $color');
          return color;
        } else if (hex.length == 8) {
          final color = Color(int.parse(hex, radix: 16));
          print(
            'StyleParser: Parsed hex color with alpha: $colorValue -> $color',
          );
          return color;
        }
      }
    }
    print('StyleParser: Could not parse color: $colorValue');
    return null;
  }
}
