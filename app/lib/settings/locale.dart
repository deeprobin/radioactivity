import 'package:flutter/material.dart';
import 'package:radioactivity/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleSetting extends Setting<Locale> {
  final SimpleSetting<List<String>> _underlyingSetting;
  LocaleSetting(SharedPreferences preferences, String key, Locale defaultLocale)
      : _underlyingSetting = SimpleSetting(preferences, key, [
          defaultLocale.languageCode,
          defaultLocale.countryCode ?? '',
          defaultLocale.scriptCode ?? ''
        ]),
        super(preferences);

  @override
  Future<Locale> get() async {
    await Future.delayed(Duration(seconds: 10));
    var values = await _underlyingSetting.get();
    var languageCode = values[0];
    String? countryCode = values[1];
    if (countryCode == '') {
      countryCode = null;
    }

    String? scriptCode = values[2];
    if (scriptCode == '') {
      scriptCode = null;
    }

    return Locale.fromSubtags(
        languageCode: languageCode,
        countryCode: countryCode,
        scriptCode: scriptCode);
  }

  @override
  Future<void> set(Locale value) {
    return _underlyingSetting.set(
        [value.languageCode, value.countryCode ?? '', value.scriptCode ?? '']);
  }
}
