import 'package:flutter/material.dart';
import 'json_theme.dart';
import 'json_router.dart';
import 'services/config_manager.dart';

class DynamicApp extends StatelessWidget {
  const DynamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData =
        JsonThemeInterpreter(
          ConfigManager.theme,
          ConfigManager.textStyles,
        ).toThemeData();

    return MaterialApp(
      title: ConfigManager.appName,
      theme: themeData,
      onGenerateRoute:
          (settings) => JsonRouterInterpreter(
            ConfigManager.routes ?? {},
          ).onGenerateRoute(settings),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
