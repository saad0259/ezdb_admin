import 'package:flutter/cupertino.dart';

import '../util/prefs.dart';

class ThemeState extends ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  ThemeState() {
    _loadTheme();
  }

  void switchDarkTheme() async {
    _darkTheme = !_darkTheme;
    try {
      await prefs.selectedTheme.save(_darkTheme);
    } catch (e) {}
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    try {
      _darkTheme = await prefs.selectedTheme.load();
    } catch (e) {
      _darkTheme = false;
    }
    notifyListeners();
  }

  Future<void> reset() async {
    _darkTheme = false;
    try {
      await prefs.selectedTheme.save(_darkTheme);
    } catch (e) {}
    notifyListeners();
  }
}
