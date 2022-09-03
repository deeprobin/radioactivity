import 'package:flutter/material.dart';
import 'package:radioactivity/generated/l10n.dart';
import 'package:radioactivity/pages/main.dart';
import 'package:radioactivity/pages/maps.dart';
import 'package:radioactivity/pages/results.dart';
import 'package:radioactivity/pages/settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() {
  runApp(const RadioactivityApp());
}

class RadioactivityApp extends StatelessWidget {
  const RadioactivityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.yellow,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.yellow,
        ),
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              title: 'Radioactivity',
              theme: theme,
              darkTheme: darkTheme,
              initialRoute: "/",
              debugShowCheckedModeBanner: false,
              routes: {
                '/': (context) => MainPage(),
                '/maps': (context) => MapsPage(),
                '/results': (context) => ResultsPage(),
                '/settings': (context) => SettingsPage()
              },
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                LocaleNamesLocalizationsDelegate(),
                S.delegate
              ],
              supportedLocales: [
                const Locale('en', ''),
                const Locale('de', '')
              ],
            ));
  }
}
