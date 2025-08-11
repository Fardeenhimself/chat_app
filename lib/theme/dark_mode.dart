import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(255, 24, 44, 37),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 30, 69, 62),
    onSecondary: Colors.white,
    tertiary: Color.fromARGB(255, 48, 104, 68),
    inversePrimary: Color.fromARGB(255, 24, 44, 37),
    surface: Color.fromARGB(255, 24, 44, 37),
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  //scaffoldBackgroundColor: Color.fromARGB(255, 219, 255, 239),
  appBarTheme: AppBarTheme().copyWith(
    centerTitle: true,
    backgroundColor: Color.fromARGB(255, 24, 44, 37),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);
