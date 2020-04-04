import 'package:collection/collection.dart';
import 'package:fivekmrun_flutter/state/run_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BestTimesByRouteChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BestTimesByRouteChart(this.seriesList, {this.animate});

  factory BestTimesByRouteChart.withRuns(List<Run> runs) {
    return new BestTimesByRouteChart(
      _createData(runs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IntrinsicHeight(child: Text("Рекорди по трасета")),
        Expanded(
            child: charts.BarChart(
              seriesList,
              animate: this.animate,
              vertical: false,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              // Hide domain axis.
              domainAxis: new charts.OrdinalAxisSpec(
                  renderSpec: new charts.NoneRenderSpec()),
                      primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: charts.NoneRenderSpec())
            ))
      ],
    );
  }

  static List<charts.Series<BestTimeByRouteEntry, String>> _createData(
      List<Run> runs) {
    List<BestTimeByRouteEntry> series = groupBy(runs, (r) => r.location)
        .entries
        .map((e) => BestTimeByRouteEntry(e.key,
            minBy<Run, int>(e.value, (r) => r.timeInSeconds).timeInSeconds))
        .toList();

    return [
      new charts.Series<BestTimeByRouteEntry, String>(
        id: 'BestTimeByRoute',
        domainFn: (BestTimeByRouteEntry run, _) => run.location,
        measureFn: (BestTimeByRouteEntry run, _) => run.timeInSeconds,
        labelAccessorFn: (BestTimeByRouteEntry run, _) =>
            "${run.location}: ${run.timeInSeconds}",
        data: series,
      )
    ];
  }
}

class BestTimeByRouteEntry {
  final String location;
  final int timeInSeconds;

  BestTimeByRouteEntry(this.location, this.timeInSeconds);
}
