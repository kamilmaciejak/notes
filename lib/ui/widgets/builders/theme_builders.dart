import 'package:flutter/material.dart';
import 'package:notes/ui/widgets/utils/constants.dart';

ThemeData buildTheme() {
  final ThemeData themeData = ThemeData.light();
  return themeData.copyWith(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      cursorColor: globalColor,
      textSelectionHandleColor: globalColor,
      textTheme: _buildTextTheme(themeData),
      iconTheme: themeData.iconTheme.copyWith(
        color: globalColor,
      ));
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
    primarySwatch: Colors.grey,
    cursorColor: Colors.redAccent,
    textSelectionHandleColor: Colors.redAccent,
  );
}

TextTheme _buildTextTheme(ThemeData themeData) {
  final textTheme = themeData.textTheme;
  return textTheme.copyWith(
    body1: textTheme.body1.copyWith(
      color: globalColor,
    ),
    subhead: textTheme.subtitle.copyWith(
      color: globalColor,
    ),
  );
}
