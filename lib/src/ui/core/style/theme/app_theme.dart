import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: grandisExtendedFont,
      primarySwatch: materialAzul,
      primaryColor: azulPadrao,
      scaffoldBackgroundColor: Colors.white70,
      iconTheme: const IconThemeData(color: blackColor),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: blackColor40)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(materialVerde.shade100),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shadowColor: WidgetStatePropertyAll(verdePadrao),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(materialVerde.shade100),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadious),
          borderSide: const BorderSide(color: verdePadrao),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: verdePadrao),
      ),
      appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
      scrollbarTheme: ScrollbarThemeData(),
      dataTableTheme: DataTableThemeData(),
    );
  }
}
