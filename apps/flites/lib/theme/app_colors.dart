import 'package:flutter/material.dart';

class AppColors {
  // Shared
  static const accent = Color.fromRGBO(150, 78, 255, 1);
  static const accentDimmed = Color.fromARGB(255, 116, 50, 214);
  static const accentDimmest = Color.fromARGB(255, 87, 31, 172);

  // Light Theme
  static const surfaceLight =
      Color.fromRGBO(245, 248, 249, 1); // Canvas + tool buttons
  static const secondarySurfaceLight =
      Color.fromRGBO(220, 228, 233, 1); // Sidebars
  static const toolBgLight = Color.fromRGBO(255, 255, 255, 1); // Tool buttons
  static const contentLight =
      Color.fromRGBO(50, 50, 50, 1); // All text, icons, tools

  // Dark Theme
  static const surfaceDark = Color.fromRGBO(53, 54, 58, 1); // Canvas
  static const secondarySurfaceDark = Color.fromRGBO(32, 32, 35, 1); // Sidebars
  static const toolBgDark = Color.fromRGBO(73, 74, 77, 1); // Tool buttons
  static const contentDark = Color.fromRGBO(215, 215, 216, 1); // Text, icons
  static const activeDark = Color.fromRGBO(234, 234, 234, 1); // Active button
}
