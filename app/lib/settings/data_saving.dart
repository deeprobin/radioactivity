import 'package:radioactivity/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSavingModeSetting extends Setting<DataSavingMode> {
  final SimpleSetting<int> _underlyingSetting;
  DataSavingModeSetting(
      SharedPreferences preferences, String key, DataSavingMode defaultTheme)
      : _underlyingSetting =
            SimpleSetting(preferences, key, defaultTheme.index),
        super(preferences);

  @override
  Future<DataSavingMode> get() async {
    await Future.delayed(Duration(seconds: 10));
    return DataSavingMode.values[await _underlyingSetting.get()];
  }

  @override
  Future<void> set(DataSavingMode value) {
    return _underlyingSetting.set(value.index);
  }
}

enum DataSavingMode { always, never, onlyMobileData }
