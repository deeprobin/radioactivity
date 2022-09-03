import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Setting<T> {
  @protected
  final SharedPreferences preferences;

  Setting(this.preferences);

  Future<T> get();
  Future<void> set(T value);
}

class SimpleSetting<T> extends Setting<T> {
  final String _key;
  final T _default;
  SimpleSetting(super.preferences, this._key, this._default) {
    if (!(T == int ||
        T == double ||
        T == bool ||
        (T == List<String>) ||
        T == String)) {
      throw ArgumentError.value(T, 'T', 'Unsupported type');
    }
  }

  @override
  Future<T> get() async {
    if (T == List<String>) {
      T? value = (await super.preferences.getStringList(_key)) as T?;
      return value ?? _default;
    }
    T? value = await super.preferences.get(_key) as T?;
    return value ?? _default;
  }

  @override
  Future<void> set(T value) {
    if (T == String) {
      return super.preferences.setString(_key, value as String);
    } else if (T == int) {
      return super.preferences.setInt(_key, value as int);
    } else if (T == double) {
      return super.preferences.setDouble(_key, value as double);
    } else if (T == bool) {
      return super.preferences.setBool(_key, value as bool);
    } else if (T == List<String>) {
      return super.preferences.setStringList(_key, value as List<String>);
    }
    throw ArgumentError.value(value, 'value', 'Unsupported type');
  }
}
