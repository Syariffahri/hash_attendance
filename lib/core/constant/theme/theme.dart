import 'package:flutter/material.dart';

final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blueAccent,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black38,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueAccent,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
);
