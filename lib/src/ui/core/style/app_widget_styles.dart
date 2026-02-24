import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppWidgetStyles {
  static final defaultInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.inputBorder, width: 1.3),
  );

  static final focusedInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primary, width: 1.3),
  );

  static final focusedErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.error, width: 1.3),
  );

  static final disabledInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.inputBorder.withValues(alpha: 0.5),
      width: 1.3,
    ),
  );
}
