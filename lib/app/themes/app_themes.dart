import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_source/app/themes/variables.dart';

class AppTheme {
  const AppTheme._();

  static Color lightBackgroundColor = const Color(0xfff1f1f1);
  static Color lightPrimaryColor = Colors.blueAccent;
  static Color lightAccentColor = Colors.deepOrangeAccent;
  static Color lightSecondaryColor = const Color(0xfff1f1f1);

  static Color darkBackgroundColor = const Color(0xFF1A2127);
  static Color darkPrimaryColor = const Color(0xFF1A2127);
  static Color darkAccentColor = Colors.blueGrey.shade600;

  static Color whiteColor = Colors.white;
  static Color greyColor = const Color(0xff9aa0a6);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.white,
    ),
    backgroundColor: lightBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Montserrat',
    textTheme: ThemeVariables.textTheme,
    iconTheme: ThemeVariables.iconTheme,
    cardColor: whiteColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.only(right: 6, left: 6),
        minimumSize: const Size(70, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    backgroundColor: darkBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Montserrat',
    textTheme: ThemeVariables.textTheme,
    iconTheme: ThemeVariables.iconTheme,
    cardColor: whiteColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.only(right: 6, left: 6),
        minimumSize: const Size(70, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
  );
}
