import 'dart:math';

import 'package:fivekmrun_flutter/state/run_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import "package:collection/collection.dart";

class RunsByRouteChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  RunsByRouteChart(this.seriesList, {this.animate});

  factory RunsByRouteChart.withRuns(List<Run> runs) {
    return new RunsByRouteChart(
      _createData(runs),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      IntrinsicHeight(child: Text("Бягания по трасета")),
      Expanded(
          child: new charts.PieChart(seriesList, animate: animate, behaviors: [
        new charts.DatumLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.end,
          // For a legend that is positioned on the left or right of the chart,
          // setting the justification for [endDrawArea] is aligned to the
          // bottom of the chart draw area.
          //outsideJustification: charts.OutsideJustification.endDrawArea,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
        )
      ])),
    ]);
  }

  static List<charts.Series<RunsByRouteEntry, String>> _createData(
      List<Run> runs) {
    List<RunsByRouteEntry> series = groupBy(runs, (r) => r.location)
        .entries
        .map((e) => RunsByRouteEntry(e.key, e.value.length))
        .toList();

    return [
      new charts.Series<RunsByRouteEntry, String>(
        id: 'RunsByRoute',
        domainFn: (RunsByRouteEntry run, _) => run.location,
        measureFn: (RunsByRouteEntry run, _) => run.timeInSeconds,
        data: series,
      )
    ];
  }
}

class RunsByRouteEntry {
  final String location;
  final int timeInSeconds;

  RunsByRouteEntry(this.location, this.timeInSeconds);
}
