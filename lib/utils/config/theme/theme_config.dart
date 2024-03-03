import 'package:ethread_app/utils/config/color/colors.dart';
import 'package:ethread_app/utils/config/font/font_family.dart';
import 'package:ethread_app/utils/config/font/font_size.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  Color gradientDark = const Color(0xFF116F42);
  Color gradientLight = const Color(0xFF6EB442);
  Color inactiveColor = const Color(0xFFB9B9B9);

  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xfff2f2f2),
      primarySwatch: Pallete.primarySwatchColor,
      splashColor: const Color(0xff489842),
      appBarTheme:  AppBarTheme(
          elevation: 0,
          backgroundColor: const Color(0xfff2f2f2),
          titleTextStyle: TextStyle(
              fontSize: FontSize.font17,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.fontFamily2),
          iconTheme: const IconThemeData(
            color: Color(0xff489842),
          ),
          actionsIconTheme: const IconThemeData(
            color: Colors.black,
          )),
      cardTheme: const CardTheme(
        color: Colors.white,
        shadowColor: Colors.white30,
      ),
      textTheme:  TextTheme(
        headline1: TextStyle(
            fontSize: FontSize.font35,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily1),
        headline2: TextStyle(
            fontSize: FontSize.font28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
        headline3: TextStyle(
            fontSize: FontSize.font22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
        headline4: TextStyle(
            fontSize: FontSize.font13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
        subtitle1: TextStyle(
            fontSize: FontSize.font14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
        subtitle2: TextStyle(
            fontSize: FontSize.font12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
        bodyText1: TextStyle(
            fontSize: FontSize.font16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
        bodyText2: TextStyle(
            fontSize: FontSize.font14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: FontFamily.fontFamily2),
      ),
      iconTheme: const IconThemeData(color: Color(0xff489842)));
}
