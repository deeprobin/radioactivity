// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settingTitle {
    return Intl.message(
      'Settings',
      name: 'settingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settingThemeTitle {
    return Intl.message(
      'Theme',
      name: 'settingThemeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select your theme`
  String get settingThemeDescription {
    return Intl.message(
      'Select your theme',
      name: 'settingThemeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settingThemeValueDark {
    return Intl.message(
      'Dark',
      name: 'settingThemeValueDark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settingThemeValueLight {
    return Intl.message(
      'Light',
      name: 'settingThemeValueLight',
      desc: '',
      args: [],
    );
  }

  /// `System ({systemTheme})`
  String settingThemeValueSystem(Object systemTheme) {
    return Intl.message(
      'System ($systemTheme)',
      name: 'settingThemeValueSystem',
      desc: '',
      args: [systemTheme],
    );
  }

  /// `Data saving mode`
  String get settingDsmTitle {
    return Intl.message(
      'Data saving mode',
      name: 'settingDsmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select your data saving mode`
  String get settingDsmDescription {
    return Intl.message(
      'Select your data saving mode',
      name: 'settingDsmDescription',
      desc: '',
      args: [],
    );
  }

  /// `Always`
  String get settingDsmValueAlways {
    return Intl.message(
      'Always',
      name: 'settingDsmValueAlways',
      desc: '',
      args: [],
    );
  }

  /// `Never`
  String get settingDsmValueNever {
    return Intl.message(
      'Never',
      name: 'settingDsmValueNever',
      desc: '',
      args: [],
    );
  }

  /// `Only mobile data`
  String get settingDsmValueOnlyMobileData {
    return Intl.message(
      'Only mobile data',
      name: 'settingDsmValueOnlyMobileData',
      desc: '',
      args: [],
    );
  }

  /// `Locale`
  String get settingLocaleTitle {
    return Intl.message(
      'Locale',
      name: 'settingLocaleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select your locale`
  String get settingLocaleDescription {
    return Intl.message(
      'Select your locale',
      name: 'settingLocaleDescription',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
