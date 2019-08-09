import 'package:flutter/material.dart';
import 'package:notes/ui/widgets/utils/constants.dart';

void changeFocus(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

void showSnackBar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
}

bool isDarkTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color getBackgroundColor(BuildContext context) => isDarkTheme(context)
    ? Theme.of(context).scaffoldBackgroundColor
    : globalColor;

Color getTextColor(BuildContext context) => isDarkTheme(context)
    ? null
    : globalColor;

Color getIconButtonColor(BuildContext context) => isDarkTheme(context)
    ? Theme.of(context).scaffoldBackgroundColor
    : globalColor;
