import 'package:flutter/material.dart';
import 'services/config_manager.dart';

class JsonThemeInterpreter {
  final Map<String, dynamic>? theme;
  final Map<String, dynamic>? textStyles;
  JsonThemeInterpreter(this.theme, this.textStyles);

  ThemeData toThemeData() {
    print('JsonThemeInterpreter: Building theme with config: $theme');

    final primaryColor = _parseColor(theme?['primaryColor']) ?? Colors.white;
    final secondaryColor =
        _parseColor(theme?['secondaryColor']) ?? Colors.white;
    final backgroundColor =
        _parseColor(theme?['backgroundColor']) ?? Colors.white;
    final surfaceColor =
        _parseColor(theme?['surfaceColor']) ?? Colors.grey[100]!;
    final errorColor = _parseColor(theme?['errorColor']) ?? Colors.white;

    print(
      'JsonThemeInterpreter: Parsed colors - primary: $primaryColor, secondary: $secondaryColor, background: $backgroundColor',
    );

    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: _parseColor(theme?['onPrimaryColor']) ?? Colors.white,
        onSecondary: _parseColor(theme?['onSecondaryColor']) ?? Colors.white,
        onSurface: _parseColor(theme?['onSurfaceColor']) ?? Colors.white,
        onError: _parseColor(theme?['onErrorColor']) ?? Colors.white,
        background: backgroundColor,
        onBackground: _parseColor(theme?['onBackgroundColor']) ?? Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: _parseColor(theme?['onPrimaryColor']) ?? Colors.white,
        elevation: 4,
      ),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor:
              _parseColor(theme?['onPrimaryColor']) ?? Colors.white,
          textStyle: _parseTextStyle(textStyles?['button']),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: _parseTextStyle(textStyles?['button']),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      headlineLarge: _parseTextStyle(textStyles?['heading']),
      headlineMedium: _parseTextStyle(textStyles?['subheading']),
      bodyLarge: _parseTextStyle(textStyles?['body']),
      bodyMedium: _parseTextStyle(textStyles?['body']),
      bodySmall: _parseTextStyle(textStyles?['caption']),
      labelLarge: _parseTextStyle(textStyles?['button']),
    );
  }

  TextStyle? _parseTextStyle(Map<String, dynamic>? style) {
    if (style == null) return null;
    return TextStyle(
      color: _parseColor(style['color']),
      fontSize: (style['fontSize'] as num?)?.toDouble(),
      fontWeight: _parseFontWeight(style['fontWeight']),
      decoration:
          style['decoration'] == 'underline' ? TextDecoration.underline : null,
    );
  }

  FontWeight? _parseFontWeight(dynamic weight) {
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

  Color? _parseColor(dynamic colorString) {
    if (colorString is String) {
      // Check if it's a color palette reference
      if (!colorString.startsWith('#')) {
        final paletteColor = ConfigManager.getColorFromPalette(colorString);
        if (paletteColor != null) {
          colorString = paletteColor;
        }
      }

      // Parse hex color
      if (colorString.startsWith('#')) {
        final hex = colorString.replaceFirst('#', '');
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      }
    }
    return null;
  }
}
