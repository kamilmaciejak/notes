import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/ui/widgets/utils/callbacks.dart';

class CustomTextField extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final SavedCallback onSaved;
  final ValueChanged<String> onFieldSubmitted;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final int maxLines;
  final bool expands;
  final int maxLength;
  final TextInputType keyboardType;

  CustomTextField({
    Key key,
    @required this.validator,
    @required this.onSaved,
    this.onFieldSubmitted,
    @required this.hintText,
    @required this.icon,
    @required this.controller,
    this.textInputAction = TextInputAction.newline,
    this.focusNode,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines,
    this.expands = false,
    this.maxLength,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: (value) => onSaved(context, value),
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.black12,
        icon: Icon(icon),
      ),
      controller: controller,
      textInputAction: textInputAction,
      focusNode: focusNode,
      obscureText: obscureText,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
