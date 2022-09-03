import 'package:meta/meta.dart';

@sealed
@immutable
@internal
class MeasuringStation {
  final String kenn;
  final double latitude;
  final double longitude;
  final String? zipCode;
  final String? name;

  MeasuringStation({
    required this.kenn,
    required this.latitude,
    required this.longitude,
    this.zipCode,
    this.name,
  });

  MeasuringStation.fromJson(Map<String, dynamic> json)
      : kenn = json['Kenn'] as String,
        latitude = json['Latitude'] as double,
        longitude = json['Longitude'] as double,
        zipCode = json['ZipCode'] as String?,
        name = json['Name'] as String?;
}
