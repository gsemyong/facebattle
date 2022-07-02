import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/radii.dart';
import 'package:flutter/material.dart';

class AppBorders {
  static const border = RoundedRectangleBorder(
    side: BorderSide(width: 2, color: AppColors.text),
    borderRadius: AppRadii.borderRadius,
  );

  static const ghostBorder = RoundedRectangleBorder(
    borderRadius: AppRadii.borderRadius,
  );

  AppBorders._();
}
