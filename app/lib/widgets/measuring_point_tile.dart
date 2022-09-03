import 'package:flutter/material.dart';
import 'package:radioactivity/api/models/geometry.dart';
import 'package:radioactivity/services/settings.dart';

class MeasuringPointTile extends StatefulWidget {
  final String name;
  final String? plz;
  final String kenn;
  final String geometryName;
  final GeometryPoint geometryPoint;
  final double? value;
  final String unit;
  final GestureTapCallback? onTap;

  MeasuringPointTile(
      {required this.name,
      required this.plz,
      required this.kenn,
      required this.geometryName,
      required this.geometryPoint,
      required this.value,
      required this.unit,
      this.onTap});

  @override
  State<StatefulWidget> createState() => _MeasuringPointTileState(
      name: name,
      plz: plz,
      kenn: kenn,
      geometryName: geometryName,
      geometryPoint: geometryPoint,
      value: value,
      unit: unit,
      onTap: onTap);
}

class _MeasuringPointTileState extends State<MeasuringPointTile> {
  final String name;
  final String? plz;
  final String kenn;
  final String geometryName;
  final GeometryPoint geometryPoint;
  final double? value;
  final String unit;
  final GestureTapCallback? onTap;

  _MeasuringPointTileState(
      {required this.name,
      required this.plz,
      required this.kenn,
      required this.geometryName,
      required this.geometryPoint,
      required this.value,
      required this.unit,
      this.onTap});

  Color _getColor() {
    if (value == null) {
      return Colors.black;
    }
    if (value! > 0.1) {
      return Colors.orange;
    }

    return Colors.green;
  }

  Color _getShadowColor() {
    if (value == null) {
      return Colors.black;
    }
    if (value! > 0.1) {
      return Colors.orangeAccent;
    }

    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: SettingsService.getInstance(context).then((value) =>
            value.getFavorites().then((value) => value.contains(this.kenn))),
        builder: ((context, snapshot) {
          return ListTile(
            leading: IconButton(
                onPressed: () {
                  setState(() {
                    if (snapshot.requireData) {
                      SettingsService.getInstance(context)
                          .then((value) => value.removeFavorite(this.kenn));
                    } else {
                      SettingsService.getInstance(context)
                          .then((value) => value.addFavorite(this.kenn));
                    }
                  });
                },
                icon: snapshot.hasData
                    ? (snapshot.requireData
                        ? Icon(
                            Icons.star,
                            color: Colors.amber,
                          )
                        : Icon(Icons.star_border, color: Colors.amber))
                    : CircularProgressIndicator()),
            title: Text(
                "${this.name}" + (this.plz == null ? "" : " - ${this.plz}")),
            isThreeLine: true,
            subtitle: Text(
                "${this.kenn}\n${this.geometryName}: ${this.geometryPoint.coordinates[0]} - ${this.geometryPoint.coordinates[1]}",
                maxLines: 2),
            onTap: this.onTap,
            trailing: Text(
              this.value == null
                  ? "keine Messung"
                  : "${this.value} ${this.unit}",
              style: TextStyle(
                  color: _getColor(),
                  shadows: [Shadow(color: _getShadowColor(), blurRadius: 1.0)],
                  fontSize: 24.0),
            ),
          );
        }));
  }
}
