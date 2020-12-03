import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOptions { system, light, dark }
enum FontOptions { JP, KR, TC, SC }

class ThemeModel extends ChangeNotifier{
  ThemeOptions _currentTheme;
  // FontOptions _currentFont;
  SharedPreferences _prefs;
  get currentTheme => _currentTheme;
  // get currentFont => _currentFont;

  ThemeModel() {
    _currentTheme = ThemeOptions.system;
    // _currentFont = FontOptions.JP;
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _currentTheme = ThemeOptions.values[_prefs.getInt("theme") ?? 0];
    // _currentFont = FontOptions.values[_prefs.getInt("font") ?? 0];
    notifyListeners();
  }

  Future<void> setTheme(ThemeOptions value) async {
    await _prefs.setInt("theme", value.index);
    _loadPrefs();
  }

  Future<void> setFont(FontOptions value) async {
    await _prefs.setInt("font", value.index);
    _loadPrefs();
  }

}