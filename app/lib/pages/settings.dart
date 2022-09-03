import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:radioactivity/generated/l10n.dart';
import 'package:radioactivity/services/settings.dart';
import 'package:radioactivity/settings/data_saving.dart';
import 'package:radioactivity/settings/theme.dart' as theme;
import 'package:radioactivity/widgets/future_settings_tile.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:skeletons/skeletons.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static String _getThemeDescription(BuildContext context, theme.Theme th) {
    switch (th) {
      case theme.Theme.dark:
        return S.of(context).settingThemeValueDark;
      case theme.Theme.light:
        return S.of(context).settingThemeValueLight;
      case theme.Theme.system:
        var brightness = MediaQuery.of(context).platformBrightness;
        bool isDarkMode = brightness == Brightness.dark;
        return S.of(context).settingThemeValueSystem(isDarkMode
            ? S.of(context).settingThemeValueDark
            : S.of(context).settingThemeValueLight);
    }
  }

  static String _getDataSavingDescription(
      BuildContext context, DataSavingMode dsm) {
    switch (dsm) {
      case DataSavingMode.always:
        return S.of(context).settingDsmValueAlways;
      case DataSavingMode.never:
        return S.of(context).settingDsmValueNever;
      case DataSavingMode.onlyMobileData:
        return S.of(context).settingDsmValueOnlyMobileData;
    }
  }

  void _selectTheme(BuildContext context, SettingsService settingsService) {
    var dialogFuture = showDialog<theme.Theme>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(S.of(context).settingThemeTitle),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(_getThemeDescription(context, theme.Theme.light)),
                onPressed: () => Navigator.pop(context, theme.Theme.light),
              ),
              SimpleDialogOption(
                child: Text(_getThemeDescription(context, theme.Theme.dark)),
                onPressed: () => Navigator.pop(context, theme.Theme.dark),
              ),
              SimpleDialogOption(
                child: Text(_getThemeDescription(context, theme.Theme.system)),
                onPressed: () => Navigator.pop(context, theme.Theme.system),
              ),
            ],
          );
        });

    dialogFuture.then((value) async {
      if (value != null) {
        await settingsService.setTheme(value);
        switch (value) {
          case theme.Theme.light:
            setState(() {
              AdaptiveTheme.of(context).setLight();
            });
            break;
          case theme.Theme.dark:
            setState(() {
              AdaptiveTheme.of(context).setDark();
            });
            break;
          case theme.Theme.system:
            setState(() {
              AdaptiveTheme.of(context).setSystem();
            });
            break;
        }
      }
    });
  }

  final SizedBox _skeleton =
      SizedBox(child: SkeletonLine(), width: 100, height: 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingTitle),
      ),
      body: FutureBuilder<SettingsService>(
          future: SettingsService.getInstance(context),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              var settingsService = snapshot.requireData;
              return buildSettings(context, settingsService);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })),
    );
  }

  Widget buildSettings(BuildContext context, SettingsService settingsService) {
    return SettingsList(sections: [
      SettingsSection(
        title: Text("General"),
        tiles: [
          FutureSettingsTile<Locale>(
            future: settingsService.getLocale(),
            builder: (context, snapshot) => SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text(S.of(context).settingLocaleTitle),
              description: Text(S.of(context).settingLocaleDescription),
              value: snapshot.hasData
                  ? Text(LocaleNames.of(context)!
                          .nameOf(snapshot.requireData.toLanguageTag()) ??
                      '')
                  : _skeleton,
            ),
          ),
          FutureSettingsTile<theme.Theme>(
              future: settingsService.getTheme(),
              builder: (context, snapshot) => SettingsTile.navigation(
                    title: Text(S.of(context).settingThemeTitle),
                    leading: Icon(Icons.color_lens),
                    description: Text(S.of(context).settingThemeDescription),
                    onPressed: (context) => snapshot.hasData
                        ? _selectTheme(context, settingsService)
                        : null,
                    value: snapshot.hasData
                        ? Text(
                            _getThemeDescription(context, snapshot.requireData))
                        : _skeleton,
                  )),
          FutureSettingsTile<DataSavingMode>(
              future: settingsService.getDataSavingMode(),
              builder: (context, snapshot) => SettingsTile.navigation(
                  title: Text(S.of(context).settingDsmTitle),
                  leading: Icon(Icons.data_usage),
                  description: Text(S.of(context).settingDsmDescription),
                  onPressed: snapshot.hasData ? (context) {} : null,
                  value: snapshot.hasData
                      ? Text(_getDataSavingDescription(
                          context, snapshot.requireData))
                      : _skeleton)),
        ],
      )
    ]);
  }
}
