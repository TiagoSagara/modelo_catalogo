import 'package:flutter/material.dart';
import 'package:api_produtos/src/ui/core/style/theme/app_theme.dart';

abstract final class AppThemes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    colorScheme: AppTheme.lightTheme(context).colorScheme,
  );
}
