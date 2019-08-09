import 'package:flutter/material.dart';
import 'package:notes/data/config.dart';
import 'package:notes/ui/home.dart';
import 'package:notes/ui/note.dart';
import 'package:notes/ui/widgets/builders/theme_builders.dart';

class Notes extends StatelessWidget {
  MaterialPageRoute _onGenerateRoute(RouteSettings settings) {
    WidgetBuilder widgetBuilder;
    switch (settings.name) {
      case NoteScreen.routeName:
        widgetBuilder =
            (BuildContext _) => NoteScreen(args: settings.arguments);
        break;
      default:
        throw new Exception('Invalid route: ${settings.name}');
    }
    return MaterialPageRoute(
      builder: widgetBuilder,
    );
  }

  Widget _buildApp(String name) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: name,
    theme: buildTheme(),
    darkTheme: buildDarkTheme(),
    onGenerateRoute: _onGenerateRoute,
    home: HomeScreen(),
  );

  @override
  Widget build(BuildContext context) {
    final name = Config.stringResource.appName;
    return _buildApp(name);
  }
}
