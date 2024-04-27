import 'package:flutter/material.dart';

class AppTheming {

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white ,
    primaryColor: Colors.green,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light ,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.red ,
        fontWeight: FontWeight.bold ,
        fontSize: 18
      ),
    ),
  );

  static ThemeData dartTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black54 ,
      primaryColor: Colors.black54,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.dark ,
      ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: Colors.white ,
          fontWeight: FontWeight.bold ,
          fontSize: 18
      ),
    ),
  );
}