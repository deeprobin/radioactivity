import 'dart:convert';

import 'package:api_client/src/models/measurement.dart';
import 'package:api_client/src/models/measuring_station.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:meta/meta.dart';

@sealed
@immutable
class ApiClient {
  final http.Client _client = RetryClient(http.Client());
  final Uri _baseUrl;

  ApiClient(this._baseUrl);

  Future<Iterable<MeasuringStation>> getMeasuringStations() async {
    final url = _baseUrl.resolve("/api/v1.0/MeasuringStations/");
    var response = await _client.get(url);
    assert(response.statusCode == 200);

    List<Map<String, dynamic>> decodedJson = jsonDecode(response.body);
    return decodedJson.map((jsonItem) => MeasuringStation.fromJson(jsonItem));
  }

  Future<MeasuringStation?> getMeasuringStation(String kenn) async {
    final url = _baseUrl.resolve("/api/v1.0/MeasuringStations/$kenn");
    var response = await _client.get(url);

    if (response.statusCode == 404) {
      return null;
    }
    assert(response.statusCode == 200);

    Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return MeasuringStation.fromJson(decodedJson);
  }

  Future<List<Measurement>> getMeasurements(
      String? kenn, DateTime? measurementsStartAt) async {
    final url = _baseUrl.resolve("/api/v1.0/Measurements/$kenn");
    if (measurementsStartAt != null) {
      url.queryParameters["start"] = measurementsStartAt.toIso8601String();
    }

    var response = await _client.get(url);
    assert(response.statusCode == 200);

    List<Map<String, dynamic>> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((jsonItem) => Measurement.fromJson(jsonItem))
        .toList();
  }
}
