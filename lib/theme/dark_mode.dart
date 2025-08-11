import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.black38,
    primary: Colors.green.shade600,
    secondary: Colors.green.shade700,
    tertiary: Colors.green.shade800,
    inversePrimary: Colors.green.shade300,
  ),
  //scaffoldBackgroundColor: Color.fromARGB(255, 219, 255, 239),
  appBarTheme: AppBarTheme().copyWith(
    centerTitle: true,
    backgroundColor: Colors.green.shade600,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);
