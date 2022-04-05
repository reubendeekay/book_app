import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light().copyWith(
      secondary: Colors.grey[300],
    ),
    fontFamily: 'Roboto',
  );
  static final datkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[900],
    cardColor: Colors.black,
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: Colors.black38,
    ),
    fontFamily: 'Roboto',
  );
}
