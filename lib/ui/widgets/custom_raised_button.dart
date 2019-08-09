import 'package:flutter/material.dart';
import 'package:notes/ui/widgets/utils/callbacks.dart';
import 'package:notes/ui/widgets/utils/constants.dart';
import 'package:notes/ui/widgets/utils/methods.dart';

class CustomRaisedButton extends StatelessWidget {
  final PressedCallback onPressed;
  final String text;
  final IconData icon;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  CustomRaisedButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    @required this.icon,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(vertical: largeMargin),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: enabled ? () => onPressed(context) : null,
      textColor: getTextColor(context),
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(icon),
            SizedBox(width: margin),
            Text(text),
          ],
        ),
      ),
    );
  }
}
