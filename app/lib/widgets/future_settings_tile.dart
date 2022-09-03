import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class FutureSettingsTile<T> extends AbstractSettingsTile {
  final Future<T> future;
  final AbstractSettingsTile Function(BuildContext, AsyncSnapshot<T>) builder;

  FutureSettingsTile({required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: this.future, builder: this.builder);
  }
}
