import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();

  SharedPreferences? prefs;
  Locale? _locale;
  bool loaded = false;

  Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  load() async {
    prefs = await SharedPreferences.getInstance();
    final languageCode = prefs!.getString('language_code');
    if(languageCode != null) {
      _locale = Locale(languageCode, "");
    }
    loaded = true;
  }

  get locale => _locale;
  set locale(locale) {
    _locale = locale;
    prefs!.setString('language_code', locale.languageCode);
  }
}
