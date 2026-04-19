import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_strings.dart';

class LocaleProvider extends ChangeNotifier {
  static const _languageCodeKey = 'language_code';

  Locale _locale = AppStrings.supportedLocales.first;

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);

    if (languageCode == null) {
      return;
    }

    _locale = AppStrings.supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => AppStrings.supportedLocales.first,
    );
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
  }
}
