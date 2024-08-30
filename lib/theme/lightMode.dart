import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.green,
      secondary: Colors.blue.shade200,
      inversePrimary: Colors.orange.shade300,
    ),
    useMaterial3: true,
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.blue.shade800,
      displayColor: Colors.black,
    )
);