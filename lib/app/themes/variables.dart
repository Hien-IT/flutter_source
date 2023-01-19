import 'package:flutter/material.dart';

class ThemeVariables {
  ThemeVariables._();

  static const ratio_4 = 0.15;
  static const ratio_3 = 0.24;
  static const ratio_2 = 0.38;
  static const ratio_1 = 0.62;
  static const ratio = 1.00;
  static const ratio1 = 1.62;
  static const ratio2 = 2.62;
  static const ratio3 = 4.24;

  static const sp0 = 0.0;
  static const sp1 = 4.0;
  static const sp2 = 8.0;
  static const sp3 = 12.0;
  static const sp4 = 16.0;
  static const sp5 = 24.0;
  static const sp6 = 32.0;
  static const sp7 = 40.0;
  static const sp8 = 48.0;
  static const sp10 = 40.0;
  static const sp15 = 60.0;

  static Color tcTitle = Colors.grey.shade900;
  static Color tcPrimary = Colors.grey.shade800;
  static Color tcSecondary = Colors.grey.shade700;
  static Color tcDisable = Colors.grey.shade600;

  static TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: -ratio1,
      height: 1 + ratio_2,
      color: tcTitle,
    ),
    headline2: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: -ratio_1,
      height: 1 + ratio_2,
      color: tcTitle,
    ),
    headline3: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1 + ratio_2,
      color: tcTitle,
    ),
    headline4: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      letterSpacing: ratio_3,
      height: 1 + ratio_2,
      color: tcTitle,
    ),
    headline5: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1 + ratio_2,
      color: tcTitle,
    ),
    headline6: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: ratio_4,
      height: 1 + ratio_2,
      color: tcTitle,
    ),
    subtitle1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: ratio_4,
      height: 1 + ratio_2,
      color: tcSecondary,
    ),
    subtitle2: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: ratio_4,
      height: 1 + ratio_2,
      color: tcSecondary,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: ratio_2,
      height: 1 + ratio_2,
      color: tcPrimary,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: ratio_3,
      height: 1 + ratio_2,
      color: tcPrimary,
    ),
    button: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 1 + ratio_3,
      height: 1 + ratio_2,
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: ratio_2,
      height: 1 + ratio_2,
      color: tcSecondary,
    ),
    overline: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1 + ratio_3,
      height: 1 + ratio_1,
      color: tcDisable,
    ),
  );

  static IconThemeData iconTheme = IconThemeData(
    color: tcSecondary,
  );
}
