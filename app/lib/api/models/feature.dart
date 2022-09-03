import 'package:meta/meta.dart';

import 'geometry.dart';
import 'properties.dart';

@sealed
@immutable
class Feature {
  final String id;
  final GeometryPoint geometry;
  final String geometryName;
  final FeatureProperties properties;

  Feature(this.id, this.geometry, this.geometryName, this.properties);

  Feature.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        geometry = GeometryPoint.fromJson(json['geometry']),
        geometryName = json['geometry_name'] as String,
        properties = FeatureProperties.fromJson(json['properties']);
}
