import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Custom/language_translation.dart';

Future<Locale?> setLocale(String locale) async {
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  await sharedPreference.setString("locale", locale);
  return LanguageTranslation.keys[locale];
}

Future<Locale?> getLocale() async {
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  String locale = sharedPreference.getString("locale") ?? "English";
  return LanguageTranslation.keys[locale];
}

AppLocalizations translate(BuildContext context) =>AppLocalizations.of(context)!;