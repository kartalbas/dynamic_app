import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class ConfigManager {
  static Map<String, dynamic>? _appConfig;
  static Map<String, dynamic>? _themeConfig;
  static Map<String, dynamic>? _endpointsConfig;
  static Map<String, dynamic>? _routesConfig;
  static Map<String, dynamic>? _actionsConfig;

  static Future<void> initialize() async {
    print('ConfigManager: Starting initialization...');

    // Load all configuration files
    _appConfig = await _loadConfig('assets/app_config.yaml');
    print('ConfigManager: App config loaded: $_appConfig');

    _themeConfig = await _loadConfig('assets/theme_config.yaml');
    print('ConfigManager: Theme config loaded: $_themeConfig');

    _endpointsConfig = await _loadConfig('assets/endpoints_config.yaml');
    print('ConfigManager: Endpoints config loaded');

    _routesConfig = await _loadConfig('assets/routes_config.yaml');
    print('ConfigManager: Routes config loaded');

    _actionsConfig = await _loadConfig('assets/actions_config.yaml');
    print('ConfigManager: Actions config loaded');

    print('ConfigManager: Initialization complete');
  }

  static Future<Map<String, dynamic>> _loadConfig(String assetPath) async {
    try {
      final String configString = await rootBundle.loadString(assetPath);
      final YamlMap yamlConfig = loadYaml(configString);
      return _convertYamlToMap(yamlConfig);
    } catch (e) {
      throw Exception('Failed to load config from $assetPath: $e');
    }
  }

  static dynamic _convertYamlToMap(dynamic yaml) {
    if (yaml is YamlMap) {
      final Map<String, dynamic> map = {};
      yaml.forEach((key, value) {
        map[key.toString()] = _convertYamlToMap(value);
      });
      return map;
    } else if (yaml is YamlList) {
      return yaml.map((item) => _convertYamlToMap(item)).toList();
    } else {
      return yaml;
    }
  }

  // Getters for different configurations
  static Map<String, dynamic> get appConfig => _appConfig ?? {};
  static Map<String, dynamic> get themeConfig => _themeConfig ?? {};
  static Map<String, dynamic> get endpointsConfig => _endpointsConfig ?? {};
  static Map<String, dynamic> get routesConfig => _routesConfig ?? {};
  static Map<String, dynamic> get actionsConfig => _actionsConfig ?? {};

  // Specific getters
  static String get appName => _appConfig?['appName'] ?? 'Dynamic App';
  static Map<String, dynamic>? get theme => _themeConfig?['theme'];
  static Map<String, dynamic>? get textStyles => _themeConfig?['textStyles'];
  static Map<String, dynamic>? get colorPalette =>
      _themeConfig?['colorPalette'];
  static Map<String, dynamic>? get endpoints => _endpointsConfig?['endpoints'];
  static Map<String, dynamic>? get networkConfig =>
      _endpointsConfig?['networkConfig'];
  static Map<String, dynamic>? get routes => _routesConfig?['routes'];
  static Map<String, dynamic>? get actions => _actionsConfig?['actions'];
  static Map<String, dynamic>? get actionCategories =>
      _actionsConfig?['actionCategories'];

  // Helper methods
  static Map<String, dynamic>? getActionConfig(String actionType) {
    return _actionsConfig?['actions']?[actionType];
  }

  static Map<String, dynamic>? getEndpointConfig(String endpointName) {
    return _endpointsConfig?['endpoints']?[endpointName];
  }

  static Map<String, dynamic>? getTextStyle(String styleName) {
    final style = _themeConfig?['textStyles']?[styleName];
    print('ConfigManager: Getting text style "$styleName": $style');
    return style;
  }

  static String? getColorFromPalette(String colorName) {
    final color = _themeConfig?['colorPalette']?[colorName];
    print('ConfigManager: Getting color "$colorName": $color');
    return color;
  }
}
