
import 'package:flutter/material.dart';
import 'package:pos/common/style/color.dart';

/// Typography
class AppTextStyles {
  static final heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );
  static const heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );
  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.onBackground,
    height: 1.4,
  );
  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );
}