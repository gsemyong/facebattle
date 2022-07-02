import 'package:face_battle/styles/borders.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static final primary = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      textStyle: AppTextStyles.button.copyWith(
        color: AppColors.text,
      ),
      primary: AppColors.primary,
      elevation: 0,
      shape: AppBorders.border);

  static final outlined = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    backgroundColor: AppColors.primary,
    primary: AppColors.text,
    onSurface: AppColors.text,
    side: const BorderSide(
      color: AppColors.text,
      width: 2,
    ),
    shape: AppBorders.border,
    elevation: 0,
    textStyle: AppTextStyles.button,
  );

  static final text = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    elevation: 0,
    shape: AppBorders.ghostBorder,
    textStyle: AppTextStyles.button,
  );

  static final accent = ElevatedButton.styleFrom(
      onPrimary: AppColors.accent,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      primary: AppColors.accent,
      elevation: 0,
      shape: AppBorders.border);

  static final danger = ElevatedButton.styleFrom(
      onPrimary: AppColors.danger,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      primary: AppColors.danger,
      elevation: 0,
      shape: AppBorders.border);

  AppButtonStyles._();
}
