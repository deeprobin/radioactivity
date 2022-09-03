import 'package:flutter/material.dart';
import 'package:radioactivity/api/client.dart';
import 'package:radioactivity/api/models/response.dart';
import 'package:radioactivity/pages/results.dart';
import 'package:radioactivity/services/settings.dart';
import 'package:skeletons/skeletons.dart';

class MeasuringPointCard extends StatefulWidget {
  final String kenn;

  const MeasuringPointCard({super.key, required this.kenn});

  @override
  State<StatefulWidget> createState() => _MeasuringPointCardState(this.kenn);
}

class _MeasuringPointCardState extends State<MeasuringPointCard> {
  final String kenn;
  final ApiClient _apiClient = ApiClient();

  _MeasuringPointCardState(this.kenn);
  final SizedBox _skeleton =
      SizedBox(child: SkeletonLine(), width: 100, height: 400);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse>(
      future:
          _apiClient.doRequest(kenn: this.kenn, type: DataLayer.timeseries1h),
      builder: (context, snapshot) {
        return Center(
            child: snapshot.hasData
                ? InkWell(
                    onTap: () => Navigator.pushNamed(context, "/results",
                        arguments: ResultsPageArguments(this.kenn)),
                    child: Card(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                "${snapshot.requireData.features[0].properties.name}" +
                                    (snapshot.requireData.features[0].properties
                                                .plz !=
                                            null
                                        ? "- ${snapshot.requireData.features[0].properties.plz}"
                                        : ""),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16.0)),
                            Spacer(),
                            FutureBuilder<bool>(
                                future: SettingsService.getInstance(context)
                                    .then((value) => value.getFavorites().then(
                                        (value) => value.contains(this.kenn))),
                                builder: (context, snapshot) => IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (snapshot.requireData) {
                                          SettingsService.getInstance(context)
                                              .then((value) => value
                                                  .removeFavorite(this.kenn));
                                        } else {
                                          SettingsService.getInstance(context)
                                              .then((value) =>
                                                  value.addFavorite(this.kenn));
                                        }
                                      });
                                    },
                                    icon: snapshot.hasData
                                        ? (snapshot.requireData
                                            ? Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              )
                                            : Icon(Icons.star_border,
                                                color: Colors.amber))
                                        : CircularProgressIndicator())),
                          ],
                        )
                      ],
                    )))
                : _skeleton);
      },
    );
  }
}
