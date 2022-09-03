import 'package:meta/meta.dart';

@immutable
class FeatureProperties {
  final String id;
  final String kenn;
  final String? plz;
  final String name;
  final DateTime? startMeasure;
  final DateTime? endMeasure;
  final num? value;
  final String unit;
  final int? validated;
  final String nuclide;
  final String duration;

  FeatureProperties(
      {required this.id,
      required this.kenn,
      required this.plz,
      required this.name,
      required this.startMeasure,
      required this.endMeasure,
      required this.value,
      required this.unit,
      required this.validated,
      required this.nuclide,
      required this.duration});

  FeatureProperties.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        kenn = json['kenn'] as String,
        plz = json['plz'] as String?,
        name = json['name'] as String,
        startMeasure = json['start_measure'] == null
            ? null
            : DateTime.parse(json['start_measure'] as String),
        endMeasure = json['end_measure'] == null
            ? null
            : DateTime.parse(json['end_measure'] as String),
        value = json['value'] as num?,
        unit = json['unit'] as String,
        validated = json['validated'] as int?,
        nuclide = json['nuclide'] as String,
        duration = json['duration'] as String;

  static FeatureProperties getRightFeaturePropertiesOfJson(
      Map<String, dynamic> json) {
    if (json.containsKey('kid') && json['kid'] != null) {
      return ExtendedFeatureProperties.fromJson(json);
    } else {
      return FeatureProperties.fromJson(json);
    }
  }
}

@sealed
@immutable
class ExtendedFeatureProperties extends FeatureProperties {
  final String siteStatus;
  final int kid;
  final num heightAboutSea;
  final num? valueCosmic;
  final num? valueTerrestrial;

  ExtendedFeatureProperties(
      {required super.id,
      required super.kenn,
      required super.plz,
      required super.name,
      required super.startMeasure,
      required super.endMeasure,
      required super.value,
      required super.unit,
      required super.validated,
      required super.nuclide,
      required super.duration,
      required this.siteStatus,
      required this.kid,
      required this.heightAboutSea,
      required this.valueCosmic,
      required this.valueTerrestrial});

  ExtendedFeatureProperties.fromJson(Map<String, dynamic> json)
      : siteStatus = json['site_status'] as String,
        kid = json['kid'] as int,
        heightAboutSea = json['height_about_sea'] as num,
        valueCosmic = json['value_cosmic'] as num?,
        valueTerrestrial = json['value_terrestrial'] as num?,
        super.fromJson(json);
}
