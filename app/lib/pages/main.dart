import 'package:flutter/material.dart';
import 'package:radioactivity/delegates/search.dart';
import 'package:radioactivity/services/settings.dart';
import 'package:radioactivity/widgets/measuring_point_card.dart';
import '../api/client.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Main Page'),
          actions: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, "/settings"),
                icon: Icon(Icons.settings)),
            IconButton(
                onPressed: () => Navigator.pushNamed(context, "/maps"),
                icon: Icon(Icons.map)),
            IconButton(
                onPressed: () => showSearch(
                    context: context, delegate: MainSearchDelegate(_apiClient)),
                icon: Icon(Icons.search))
          ],
        ),
        body: Column(
          children: [
            Text("Favorites",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700)),
            FutureBuilder(
                future: SettingsService.getInstance(context)
                    .then((value) => value.getFavorites()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.requireData
                            .map((e) => MeasuringPointCard(kenn: e))
                            .toList());
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ));
  }
}
