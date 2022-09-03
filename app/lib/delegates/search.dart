import 'package:flutter/material.dart';
import 'package:radioactivity/api/client.dart';
import 'package:radioactivity/api/models/response.dart';
import 'package:radioactivity/pages/results.dart';
import 'package:radioactivity/widgets/measuring_point_tile.dart';
import 'package:string_similarity/string_similarity.dart';

class MainSearchDelegate extends SearchDelegate {
  final ApiClient _apiClient;

  MainSearchDelegate(this._apiClient);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<ApiResponse>(
        future: _apiClient.doRequest(
            type: DataLayer.onehlatest, maxFeatures: 100, name: "*${query}*"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            var features = data.features;
            features.sort((f1, f2) => query.similarityTo(f1.properties.name) >
                    query.similarityTo(f2.properties.name)
                ? -1
                : 1);
            return ListView.builder(
                itemCount: data.numberReturned,
                itemBuilder: (context, index) {
                  var item = data.features[index];
                  var itemProperties = item.properties;
                  return MeasuringPointTile(
                    name: itemProperties.name,
                    plz: itemProperties.plz,
                    kenn: itemProperties.kenn,
                    geometryName: item.geometryName,
                    geometryPoint: item.geometry,
                    value: itemProperties.value?.toDouble(),
                    unit: itemProperties.unit,
                    onTap: () => {
                      Navigator.pushNamed(context, "/results",
                          arguments: ResultsPageArguments(itemProperties.kenn))
                    },
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
