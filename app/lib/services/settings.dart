import 'package:flutter/material.dart';
import 'package:radioactivity/settings/data_saving.dart';
import 'package:radioactivity/settings/locale.dart';
import 'package:radioactivity/settings/setting.dart';
import 'package:radioactivity/settings/theme.dart' as theme;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final Setting<Locale> _localeSetting;
  final Setting<theme.Theme> _themeSetting;
  final Setting<DataSavingMode> _dataSavingModeSetting;
  final Setting<List<String>> _favoritesSetting;

  SettingsService._create(SharedPreferences prefs, BuildContext context)
      : _localeSetting =
            LocaleSetting(prefs, "locale", Localizations.localeOf(context)),
        _themeSetting = theme.ThemeSetting(prefs, "theme", theme.Theme.system),
        _dataSavingModeSetting = DataSavingModeSetting(
            prefs, "data_saving_mode", DataSavingMode.onlyMobileData),
        _favoritesSetting = SimpleSetting<List<String>>(prefs, "favorites", []);

  Future<Locale> getLocale() => _localeSetting.get();
  Future<void> setLocale(Locale locale) => _localeSetting.set(locale);

  Future<theme.Theme> getTheme() => _themeSetting.get();
  Future<void> setTheme(theme.Theme theme) => _themeSetting.set(theme);

  Future<DataSavingMode> getDataSavingMode() => _dataSavingModeSetting.get();
  Future<void> setDataSavingMode(DataSavingMode dsm) =>
      _dataSavingModeSetting.set(dsm);

  Future<List<String>> getFavorites() => _favoritesSetting.get();
  Future<void> addFavorite(String kenn) async {
    var favorites = await getFavorites();
    favorites.add(kenn);
    await _favoritesSetting.set(favorites);
  }

  Future<void> removeFavorite(String kenn) async {
    var favorites = await getFavorites();
    favorites.remove(kenn);
    await _favoritesSetting.set(favorites);
  }

  static Future<SettingsService> getInstance(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return SettingsService._create(prefs, context);
  }
}
