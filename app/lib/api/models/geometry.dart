import 'package:meta/meta.dart';

@sealed
@immutable
class GeometryPoint {
  final List<double> coordinates;

  GeometryPoint(this.coordinates) {
    assert(coordinates.length == 2);
  }

  GeometryPoint.fromJson(Map<String, dynamic> json)
      : coordinates = List<num>.from(json['coordinates'])
            .map((e) => e.toDouble())
            .toList();
}
