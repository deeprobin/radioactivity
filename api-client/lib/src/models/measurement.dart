import 'package:meta/meta.dart';

@sealed
@immutable
@internal
class Measurement {
  final DateTime timestamp;
  final double value;
  final double? valueCosmic;
  final double? valueTerrestrial;
  final String? unit;
  final String? nuclide;
  final bool validated;

  Measurement({
    required this.timestamp,
    required this.value,
    this.valueCosmic,
    this.valueTerrestrial,
    this.unit,
    this.nuclide,
    required this.validated,
  });

  Measurement.fromJson(Map<String, dynamic> json)
      : timestamp = DateTime.parse(json['Timestamp'] as String),
        value = json['Value'] as double,
        valueCosmic = json['ValueCosmic'] as double?,
        valueTerrestrial = json['ValueTerrestrial'] as double?,
        unit = json['Unit'] as String?,
        nuclide = json['Nuclide'] as String?,
        validated = json['Validated'] as bool;
}
