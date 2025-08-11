import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color.fromARGB(255, 120, 216, 161),
    onPrimary: Colors.black,
    secondary: Color.fromARGB(255, 153, 255, 201),
    onSecondary: Colors.black,
    tertiary: Color.fromARGB(255, 131, 231, 168),
    inversePrimary: Color.fromARGB(255, 194, 255, 226),
    surface: Color.fromARGB(255, 219, 255, 239),
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 219, 255, 239),
  appBarTheme: AppBarTheme().copyWith(
    centerTitle: true,
    backgroundColor: Color.fromARGB(255, 219, 255, 239),
  ),

  textTheme: GoogleFonts.poppinsTextTheme(),
);
