import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../model/chart_data_model.dart';

class DashboardChartView extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ChartDataModel> chartData;

  const DashboardChartView({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(6.0) + const EdgeInsets.only(right: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 2),
          SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
              enable: true,
            ),
            plotAreaBorderWidth: 0,
            borderWidth: 0,
            title: ChartTitle(
              text: subtitle,
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
            series: getDefaultData(),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.yMd(),
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
          ),
        ]),
      ),
    );
  }

  List<SplineSeries<ChartDataModel, DateTime>> getDefaultData() {
    return <SplineSeries<ChartDataModel, DateTime>>[
      SplineSeries<ChartDataModel, DateTime>(
        name: '',
        markerSettings: const MarkerSettings(isVisible: true),
        dataSource: chartData,
        xValueMapper: (ChartDataModel sales, _) => sales.date,
        yValueMapper: (ChartDataModel sales, _) => sales.value,
        width: 3,
      ),
    ];
  }
}
