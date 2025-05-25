import 'package:campus_sheba/dynamic_app.dart';
import 'package:campus_sheba/networking/network_utils.dart';
import 'package:campus_sheba/services/config_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all configurations
  await ConfigManager.initialize();

  // Initialize NetworkUtils with endpoints from config
  if (ConfigManager.endpoints != null) {
    NetworkUtils.initialize(ConfigManager.endpoints!);
  }

  runApp(const DynamicApp());
}
