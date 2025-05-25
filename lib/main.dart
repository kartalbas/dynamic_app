import 'package:campus_sheba/dynamic_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load YAML config from assets (assets/app_config.yaml)
  final String configString = await rootBundle.loadString(
    'assets/app_config.yaml',
  );
  final YamlMap yamlConfig = loadYaml(configString);
  // Convert YamlMap to Map<String, dynamic> recursively
  final Map<String, dynamic> config = _convertYamlToMap(yamlConfig);
  runApp(DynamicApp(config: config));
}

// Recursively convert YamlMap and YamlList to regular Map and List
dynamic _convertYamlToMap(dynamic yaml) {
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
