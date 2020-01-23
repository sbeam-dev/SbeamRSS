import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOptions { system, light, dark }

class ThemeModel extends ChangeNotifier{
  ThemeOptions _currentTheme;
  SharedPreferences _prefs;
  get currentTheme => _currentTheme;

  ThemeModel() {
    _currentTheme = ThemeOptions.system;
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _currentTheme = ThemeOptions.values[_prefs.getInt("theme") ?? 0];
    notifyListeners();
  }

  Future<void> setTheme(ThemeOptions value) async {
    await _prefs.setInt("theme", value.index);
    _loadPrefs();
  }

}