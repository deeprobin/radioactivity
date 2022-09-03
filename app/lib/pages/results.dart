import 'dart:math';

//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:flutter/scheduler.dart';
import 'package:radioactivity/api/client.dart';
import 'package:radioactivity/api/models/feature.dart';
import 'package:radioactivity/api/models/properties.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart' as element;

class ResultsPageArguments {
  final String kenn;
  ResultsPageArguments(this.kenn);
}

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ResultsPageArguments;
    return Scaffold(
        appBar: AppBar(title: Text("Results")),
        body: Center(
            child: Column(
          children: [
            FutureBuilder(
                future: _apiClient.doRequest(
                    type: DataLayer.timeseries1h, kenn: args.kenn),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Column(
                          children: [
                            SizedBox(
                                height: 250.0,
                                child: charts.TimeSeriesChart(
                                  _createData(snapshot.data!.features),
                                  animate: true,
                                  defaultRenderer:
                                      new charts.LineRendererConfig(
                                          includeArea: true,
                                          stacked: true,
                                          includePoints: true),
                                  dateTimeFactory:
                                      const charts.LocalDateTimeFactory(),
                                  behaviors: [
                                    charts.LinePointHighlighter(
                                        symbolRenderer: TextSymbolRenderer(() =>
                                            Random().nextInt(100).toString()))
                                  ],
                                  selectionModels: [
                                    charts.SelectionModelConfig(changedListener:
                                        (charts.SelectionModel model) {
                                      if (model.hasDatumSelection) {}
                                    })
                                  ],
                                ))
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                })
          ],
        )));
  }

/*
  LineChartData _buildData(List<Feature> features) {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];*/
  List<charts.Series<Feature, DateTime>> _createData(List<Feature> features) {
    final valueSeries = charts.Series<Feature, DateTime>(
        id: 'Value',
        domainFn: (feature, _) =>
            feature.properties.endMeasure ?? feature.properties.endMeasure!,
        data: features,
        measureFn: (feature, _) => feature.properties.value,
        areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault);
    final terrestrialValueSeries = charts.Series<Feature, DateTime>(
        id: 'Terrestrial Value',
        domainFn: (feature, _) =>
            feature.properties.endMeasure ?? feature.properties.endMeasure!,
        data: features,
        measureFn: (feature, _) {
          if (feature.properties is ExtendedFeatureProperties) {
            var props = feature.properties as ExtendedFeatureProperties;
            return props.valueTerrestrial;
          }
          return null;
        },
        areaColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault);
    final cosmicValueSeries = charts.Series<Feature, DateTime>(
        id: 'Cosmic Value',
        domainFn: (feature, _) =>
            feature.properties.endMeasure ?? feature.properties.endMeasure!,
        data: features,
        measureFn: (feature, _) {
          if (feature.properties is ExtendedFeatureProperties) {
            var props = feature.properties as ExtendedFeatureProperties;
            return props.valueCosmic;
          }
          return null;
        },
        areaColorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault);
    return [valueSeries, terrestrialValueSeries, cosmicValueSeries];
  }
}

typedef GetText = String Function();

class TextSymbolRenderer extends CircleSymbolRenderer {
  TextSymbolRenderer(this.getText,
      {this.marginBottom = 8, this.padding = const EdgeInsets.all(8)});

  final GetText getText;
  final double marginBottom;
  final EdgeInsets padding;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    style.TextStyle textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;

    element.TextElement textElement =
        element.TextElement(getText.call(), style: textStyle);
    double width = textElement.measurement.horizontalSliceWidth;
    double height = textElement.measurement.verticalSliceWidth;

    double centerX = bounds.left + bounds.width / 2;
    double centerY = bounds.top +
        bounds.height / 2 -
        marginBottom -
        (padding.top + padding.bottom);

    canvas.drawRRect(
      Rectangle(
        centerX - (width / 2) - padding.left,
        centerY - (height / 2) - padding.top,
        width + (padding.left + padding.right),
        height + (padding.top + padding.bottom),
      ),
      fill: Color.white,
      radius: 16,
      roundTopLeft: true,
      roundTopRight: true,
      roundBottomRight: true,
      roundBottomLeft: true,
    );
    canvas.drawText(
      textElement,
      (centerX - (width / 2)).round(),
      (centerY - (height / 2)).round(),
    );
  }
}
