import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app1/interfaces/reader.dart';

class ReaderModel extends ChangeNotifier{
  String _fontFamily;
  double _fontSize;
  SharedPreferences _prefs;
  get fontFamily => _fontFamily;
  get fontSize => _fontSize;

  ReaderModel() {
    _fontSize = 17;
    _fontFamily = "serif";
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _fontFamily = _prefs.getString("fontFamily") ?? 'serif';
    _fontSize = _prefs.getDouble("fontSize") ?? 17;
    notifyListeners();
  }

  Future<void> addSize() async {
    await _prefs.setDouble("fontSize", _fontSize + 1);
    _fontSize++;
    notifyListeners();
  }

  Future<void> decreaseSize() async {
    await _prefs.setDouble("fontSize", _fontSize - 1);
    _fontSize--;
    notifyListeners();
  }

  Future<void> changeFont(RadioItem value) async {
    if (value == RadioItem.serif) {
      await _prefs.setString("fontFamily", "serif");
    } else if (value == RadioItem.sans) {
      await _prefs.setString("fontFamily", "sans");
    } else {
      await _prefs.setString("fontFamily", "NotoSans");
    }
    _loadPrefs();
  }

}