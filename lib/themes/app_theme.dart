import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryBgColor = const Color(0xFF112117);
  static Color primaryFgColor = const Color(0xFF33E67A);
  static BorderRadius cardBorderRadius = const BorderRadius.all(Radius.circular(15));

  static TextStyle textStyle({double fontSize = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.white}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }


}