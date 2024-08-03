import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

class LocalAppLocalizations {
  static final LocalAppLocalizations _singleton = LocalAppLocalizations._internal();

  static LocalAppLocalizations get instance => _singleton;

  late Map<String, String> _localizedStrings;

  LocalAppLocalizations._internal();

  Future<void> load(Locale locale) async {
    final String jsonString =
        await rootBundle.loadString('lib/src/localization/${locale.languageCode}.arb');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }

  static const LocalizationsDelegate<LocalAppLocalizations> delegate =
      _LocalAppLocalizationsDelegate();
}

class _LocalAppLocalizationsDelegate extends LocalizationsDelegate<LocalAppLocalizations> {
  const _LocalAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'uz', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<LocalAppLocalizations> load(Locale locale) async {
    final LocalAppLocalizations localizations = LocalAppLocalizations.instance;
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(_LocalAppLocalizationsDelegate old) => false;
}