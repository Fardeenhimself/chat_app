import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    onSurface: Colors.black,
    primary: Color.fromARGB(255, 120, 216, 161),
    secondary: Color.fromARGB(255, 153, 255, 201),
    tertiary: Color.fromARGB(255, 131, 231, 168),
    inversePrimary: Color.fromARGB(255, 194, 255, 226),
    error: Colors.red,
    surface: Color.fromARGB(255, 219, 255, 239),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 219, 255, 239),
  appBarTheme: AppBarTheme().copyWith(
    centerTitle: true,
    backgroundColor: Color.fromARGB(255, 153, 255, 201),
  ),

  textTheme: GoogleFonts.poppinsTextTheme(),
);
