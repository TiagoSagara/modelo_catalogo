import 'package:flutter/material.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';

abstract final class AppTextStyles {
  static const title = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: AppColors.formTitle,
    height: 32 / 24,
  );

  static const subTitle = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.fieldLabel,
    height: 32 / 24,
  );

  static const fieldLabel = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.fieldLabel,
    height: 16 / 14,
  );

  static const field = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.field,
    height: 21 / 14,
  );

  static const fieldError = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.error,
  );

  static const TextStyle formTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static final TextStyle tableHeader = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.tableHeader,
    height: 21 / 14,
  );

  static const TextStyle tableCell = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.tableHeader,
  );

  static const labelWarning = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.red,
  );
}
