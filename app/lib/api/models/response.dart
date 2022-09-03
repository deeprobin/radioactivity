import 'package:meta/meta.dart';

import 'feature.dart';

@sealed
@immutable
class ApiResponse {
  final int totalFeatures;
  final int numberReturned;
  final DateTime timeStamp;
  final List<Feature> features;

  ApiResponse(
      {required this.totalFeatures,
      required this.numberReturned,
      required this.timeStamp,
      required this.features});

  ApiResponse.fromJson(Map<String, dynamic> json)
      : totalFeatures = json['totalFeatures'] as int,
        numberReturned = json['numberReturned'] as int,
        timeStamp = DateTime.parse(json['timeStamp'] as String),
        features = (List<dynamic>.from(json['features']))
            .map((e) => Feature.fromJson(e as Map<String, dynamic>))
            .toList();
}
