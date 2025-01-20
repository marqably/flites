import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 172, 233, 255),
    primary: const Color.fromARGB(255, 97, 213, 255),
    // Main surfaces
    surface: Colors.grey[200]!,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Colors.grey[300]!,
    // Mid greys
    surfaceTint: const Color.fromARGB(255, 185, 185, 185),
    outline: const Color.fromARGB(255, 102, 102, 102),
    surfaceContainerHigh: const Color.fromARGB(255, 96, 96, 96),
    // Dark greys
    surfaceContainerHighest: const Color.fromARGB(255, 49, 49, 49),
    surfaceBright: const Color.fromARGB(255, 64, 64, 64),
    surfaceDim: const Color.fromARGB(255, 27, 27, 27),
    surfaceContainer: const Color.fromARGB(255, 22, 22, 22),
    onSurfaceVariant: const Color.fromARGB(255, 31, 31, 31),
    // Text
    onSurface: Colors.black87,
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 172, 233, 255),
    primary: const Color.fromARGB(255, 97, 213, 255),
    // Main surfaces
    surface: Colors.grey[800]!,
    surfaceContainerLowest: Colors.grey[900]!,
    surfaceContainerLow: Colors.grey[700]!,
    // Mid greys
    surfaceTint: const Color.fromARGB(255, 160, 160, 160),
    outline: const Color.fromARGB(255, 150, 150, 150),
    surfaceContainerHigh: Colors.grey[600]!,
    // Light greys
    surfaceContainerHighest: const Color.fromARGB(255, 200, 200, 200),
    surfaceBright: const Color.fromARGB(255, 180, 180, 180),
    surfaceDim: const Color.fromARGB(255, 220, 220, 220),
    surfaceContainer: const Color.fromARGB(255, 240, 240, 240),
    onSurfaceVariant: const Color.fromARGB(255, 210, 210, 210),
    // Text
    onSurface: Colors.white,
  ),
  useMaterial3: true,
);
