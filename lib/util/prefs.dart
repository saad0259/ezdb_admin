import '../flutter-utils/prefs/prefs_helper.dart';

Prefs get prefs {
  // Prefs._prefs;

  return Prefs._prefs;
}

class Prefs {
  static final _prefs = Prefs();
  final selectedTheme = PrefsHelper<bool>("theme");
  final selectedLocale = PrefsHelper<String>("selectedLocale");
}
