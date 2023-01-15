import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static Color backgroundColor = const Color(0xFFF3F8FF);
  static Color buttonbgColor = const Color(0xFFD00000);
  static Color buttonshadowColor = const Color(0xFFFFCCCC);
  static Color buttonupColor = const Color(0xFFF6FAFF);
  static Color buttondownColor = const Color(0xFFD6E3F6);
  static Color buttondownShadow  = const Color(0xFFBBC3D0);
  static Color buttontopShadow  = const Color(0xFFFFFFFF);
  //user name text style
  static TextStyle textfieldinputStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 18.0,
  ));
  static TextStyle textfieldtextLabel = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 17.0,
  ));
  static TextStyle buttonTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 18.0,
  ));
  static TextStyle wishTextStyle = GoogleFonts.openSans(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 18.0,
  ));

  static TextStyle userNameTextStyle = GoogleFonts.openSans(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
  ));

  static TextStyle emergencyMessageStyle = GoogleFonts.openSans(
      textStyle: const TextStyle(
    color: Color(0xFFFF0000),
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  ));

  static TextStyle pressbtnMessage = GoogleFonts.openSans(
      textStyle: const TextStyle(
    color: Color(0xFF626262),
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  ));
  static TextStyle btnNames = GoogleFonts.openSans(
      textStyle: const TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  ));

  //status bar color changed code
  static SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFF3F8FF), // navigation bar color
    statusBarColor: Color(0xFFF3F8FF), // status bar color
    statusBarIconBrightness: Brightness.dark, // status bar icons' color
    systemNavigationBarIconBrightness:
        Brightness.dark, //navigation bar icons' color
  );
}
