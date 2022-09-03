import 'package:radioactivity/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Theme { dark, light, system }

class ThemeSetting extends Setting<Theme> {
  final SimpleSetting<int> _underlyingSetting;
  ThemeSetting(SharedPreferences preferences, String key, Theme defaultTheme)
      : _underlyingSetting =
            SimpleSetting(preferences, key, defaultTheme.index),
        super(preferences);

  @override
  Future<Theme> get() async {
    await Future.delayed(Duration(seconds: 10));
    return Theme.values[await _underlyingSetting.get()];
  }

  @override
  Future<void> set(Theme value) {
    return _underlyingSetting.set(value.index);
  }
}
