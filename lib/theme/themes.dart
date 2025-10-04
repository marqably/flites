import 'package:flutter/material.dart';
import 'app_colors.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'SF Pro',
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    primary: AppColors.accent,
    primaryFixed: AppColors.accentDimmed,
    primaryFixedDim: AppColors.accentDimmest,
    onPrimary: AppColors.surfaceLight,

    secondary: AppColors.secondary,
    onSecondary: AppColors.surfaceLight,

    // Main surfaces
    surface: AppColors.surfaceLight,
    surfaceContainerLowest: AppColors.secondarySurfaceLight,
    surfaceContainerLow: AppColors.surfaceLight, // Same as main background
    surfaceContainer: AppColors.toolBgLight,
    // Content colors
    onSurface: AppColors.contentLight,
    onSurfaceVariant: AppColors.secondarySurfaceLight, // Same as main text
    outline: AppColors.contentLight, // Same as main text
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'SF Pro',
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: AppColors.accent,
    primary: AppColors.accent,
    primaryFixed: AppColors.accentDimmed,
    primaryFixedDim: AppColors.accentDimmest,
    onPrimary: AppColors.surfaceLight,

    secondary: AppColors.secondary,
    onSecondary: AppColors.surfaceLight,

    // Main surfaces
    surface: AppColors.surfaceDark,
    surfaceContainerLowest: AppColors.secondarySurfaceDark,
    surfaceContainerLow: AppColors.surfaceDark,
    surfaceContainer: AppColors.toolBgDark, // Same as tool background
    // Content colors
    onSurface: AppColors.contentDark,
    onSurfaceVariant: AppColors.activeDark, // Same as main text
    outline: AppColors.contentDark, // Same as main text
  ),
);
