import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_en.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'vi':
      default:
        return AppLocalizationsVi();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  static const List<Locale> supportedLocales = [
    Locale('vi', 'VN'),
    Locale('en', 'US'),
  ];
}
