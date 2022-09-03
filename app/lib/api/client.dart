import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:radioactivity/api/models/response.dart';
import 'package:xml/xml.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<ApiResponse> doRequest(
      {DataLayer? type,
      String? kenn,
      String? sortBy,
      String? name,
      int? maxFeatures,
      int? startIndex}) async {
    var params = {
      'service': 'WFS',
      'request': 'GetFeature',
      'outputFormat': 'application/json',
    };
    if (kenn != null) {
      params['viewParams'] = 'kenn:$kenn';
    }
    if (type != null) {
      params['typeName'] = type.toString();
    }
    if (sortBy != null) {
      params['sortBy'] = sortBy;
    }
    if (maxFeatures != null) {
      params['maxFeatures'] = maxFeatures.toString();
    }
    if (startIndex != null) {
      params['startIndex'] = startIndex.toString();
    }
    if (name != null) {
      params['filter'] = _buildOgcXml(name);
    }
    var uri = Uri.https('www.imis.bfs.de', 'ogc/opendata/ows', params);
    debugPrint("GET ${uri}");
    var response = await _client.get(uri);
    assert(response.statusCode >= 200 && response.statusCode < 300);
    return ApiResponse.fromJson(json.decode(response.body));
  }
}

String _buildOgcXml(String name) {
  final builder = XmlBuilder();
  builder.namespace('http://www.opengis.net/ogc', 'ogc');
  builder.namespace("http://www.opengis.net/gml", "gml");
  builder.element('ogc:Filter', nest: () {
    builder.element('ogc:PropertyIsLike', nest: () {
      builder.attribute("wildCard", "*");
      builder.attribute("singleChar", "#");
      builder.attribute("escape", "!");
      builder.element('ogc:PropertyName', nest: () {
        builder.text('name');
      });
      builder.element('ogc:Literal', nest: () {
        builder.text(name);
      });
    });
  });
  final document = builder.buildDocument();
  return document.outerXml;
}

enum DataLayer {
  onehlatest,
  timeseries1h,
  timeseries24h;

  String toString() {
    switch (this) {
      case DataLayer.onehlatest:
        return 'odlinfo_odl_1h_latest';
      case DataLayer.timeseries1h:
        return 'odlinfo_timeseries_odl_1h';
      case DataLayer.timeseries24h:
        return 'odlinfo_timeseries_odl_24h';
    }
  }
}
