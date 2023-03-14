import 'dart:math';

class ChartDataModel {
  final DateTime date;
  double value;

  ChartDataModel(DateTime date, this.value)
      : date = DateTime(date.year, date.month, date.day);

  static generateRandomData(int count) {
    return List.generate(count, (index) {
      return ChartDataModel(
        DateTime.now().subtract(Duration(days: index)),
        Random().nextInt(100).toDouble(),
      );
    });
  }
}
