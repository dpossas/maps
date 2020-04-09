import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Color.fromRGBO(16, 21, 154, 1),
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(16, 21, 154, 1),
      elevation: 0,
    ),
    textTheme: TextTheme(
      subhead: TextStyle(
        fontFamily: "Nunito",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(17, 18, 54, 1),
      ),
      body1: TextStyle(
        fontFamily: "Nunito",
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(117, 118, 133, 1),
      )
    ),
  );
}