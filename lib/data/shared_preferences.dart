import 'package:shared_preferences/shared_preferences.dart';

const prefHomeTopButtonsVisible = "prefHomeTopButtonsVisible";

Future<SharedPreferences> getSharedPreferences() async =>
    await SharedPreferences.getInstance();

Future<bool> getBool(String key) async {
  final prefs = await getSharedPreferences();
  return prefs.containsKey(key) ? prefs.getBool(key) : false;
}

Future<String> getString(String key) async {
  final prefs = await getSharedPreferences();
  return prefs.containsKey(key) ? prefs.getString(key) : '';
}

void setBool(String key, bool value) async {
  final prefs = await getSharedPreferences();
  prefs.setBool(key, value);
}

void setString(String key, String value) async {
  final prefs = await getSharedPreferences();
  prefs.setString(key, value);
}
