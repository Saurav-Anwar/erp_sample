import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryBgColor = const Color(0xFF112117);
  static Color primaryFgColor = const Color(0xFF33E67A);
  // static Color primaryCardColor = Colors.lightBlue.shade100.withAlpha(30);
  static Color primaryCardColor = const Color(0xFF21312D);
  static BorderRadius cardBorderRadius = const BorderRadius.all(Radius.circular(20));

  static TextStyle textStyle({double fontSize = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.white}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }


}