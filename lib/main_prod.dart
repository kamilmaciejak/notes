import 'package:flutter/material.dart';
import 'package:notes/data/config.dart';
import 'package:notes/main.dart';

void main() {
  Config.init(Flavor.PRODUCTION);
  runApp(Notes());
}
