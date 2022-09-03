import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:radioactivity/api/client.dart';
import 'package:radioactivity/api/models/feature.dart';
import 'package:radioactivity/api/models/response.dart';

class MapsPage extends StatefulWidget {
  MapsPage({Key? key}) : super(key: key);
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final ApiClient _apiClient = ApiClient();

  static final germany = const LatLng(51.1642292, 10.4541194);
  final controller = MapController(
    location: germany,
  );

  void _gotoDefault() {
    controller.center = germany;
    setState(() {});
  }

  void _onDoubleTap(MapTransformer transformer, Offset position) {
    const delta = 0.5;
    final zoom = clamp(controller.zoom + delta, 2, 18);

    transformer.setZoomInPlace(zoom, position);
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color,
      [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text('You have clicked a marker!'),
            ),
          );
        },
      ),
    );
  }

  static Color _getColor(Feature feature) {
    if (feature.properties.value == null) {
      return Colors.grey;
    }
    if (feature.properties.value! > 0.1) {
      return Colors.orange;
    }

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers'),
      ),
      body: FutureBuilder<ApiResponse>(
          future: _apiClient.doRequest(type: DataLayer.onehlatest),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;

              return MapLayout(
                controller: controller,
                builder: (context, transformer) {
                  final markerWidgets = data.features
                      .map(
                        (feature) => _buildMarkerWidget(
                            transformer.toOffset(LatLng(
                                feature.geometry.coordinates[0],
                                feature.geometry.coordinates[1])),
                            _getColor(feature)),
                      )
                      .toList();

                  final centerLocation = transformer.toOffset(germany);

                  final centerMarkerWidget =
                      _buildMarkerWidget(centerLocation, Colors.purple);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTapDown: (details) => _onDoubleTap(
                      transformer,
                      details.localPosition,
                    ),
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: (details) =>
                        _onScaleUpdate(details, transformer),
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          final delta = event.scrollDelta.dy / -1000.0;
                          final zoom = clamp(controller.zoom + delta, 2, 18);

                          transformer.setZoomInPlace(zoom, event.localPosition);
                          setState(() {});
                        }
                      },
                      child: Stack(
                        children: [
                          TileLayer(
                            builder: (context, x, y, z) {
                              final tilesInZoom = pow(2.0, z).floor();

                              while (x < 0) {
                                x += tilesInZoom;
                              }
                              while (y < 0) {
                                y += tilesInZoom;
                              }

                              x %= tilesInZoom;
                              y %= tilesInZoom;

                              return CachedNetworkImage(
                                imageUrl: google(z, x, y),
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          ...markerWidgets,
                          centerMarkerWidget,
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

const yourMapBoxAccessToken = '';

/// Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
String google(int z, int x, int y) {
  //Google Maps
  final url =
      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

  return url;
}

/// Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
String googleDark(int z, int x, int y) {
  final url =
      'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0';
  return url;
}

String mapbox(int z, int x, int y) {
  //Mapbox Streets
  final url =
      'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=$yourMapBoxAccessToken';

  return url;
}

double clamp(double x, double min, double max) {
  if (x < min) x = min;
  if (x > max) x = max;

  return x;
}
