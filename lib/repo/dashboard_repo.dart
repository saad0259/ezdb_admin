import 'dart:math';

import '../model/admin_dashboard_model.dart';
import '../model/chart_data_model.dart';
import '../model/enum/dashboard_filter_enum.dart';
// import '../model/transaction_model.dart';
// import 'transaction_repo.dart';

class AdminDashboardRepo {
  static final instance = AdminDashboardRepo();

  // Future<List<ChartDataModel>> _mapQueryToChartModel({
  //   required List<TransactionModel> transactions,
  //   required DateTime Function(TransactionModel doc) getDate,
  //   required double Function(TransactionModel doc) getValue,
  // }) async =>
  //     transactions
  //         .map((doc) => ChartDataModel(
  //               getDate(doc),
  //               getValue(doc),
  //             ))
  //         .toList();

  // List<ChartDataModel> _mergeValuesOfSimilarDate(List<ChartDataModel> list) {
  //   for (int i = 0; i < list.length; i++) {
  //     for (int j = i + 1; j < list.length; j++) {
  //       if (list[i].date == list[j].date) {
  //         list[i].value += list[j].value;
  //         list.removeAt(j);
  //         j--;
  //       }
  //     }
  //   }
  //   list.sort((a, b) => a.date.compareTo(b.date));
  //   return list;
  // }

  // Future<List<ChartDataModel>> _getTransactionChart(
  //         List<TransactionModel> transactions) =>
  //     _mapQueryToChartModel(
  //       transactions: transactions,
  //       getDate: (doc) {
  //         final DateTime date = doc.createdAt;
  //         return DateTime(date.year, date.month, date.day);
  //       },
  //       getValue: (doc) => 1,
  //     );

  // Future<List<ChartDataModel>> _getRevenueChart(
  //         List<TransactionModel> transactions) =>
  //     _mapQueryToChartModel(
  //       transactions: transactions,
  //       getDate: (doc) {
  //         final DateTime date = doc.createdAt;
  //         return DateTime(date.year, date.month, date.day);
  //       },
  //       getValue: (doc) => doc.isRefunded ? 0 : doc.amount,
  //     );

  // Future<List<ChartDataModel>> _getNetProfitChart(
  //         List<TransactionModel> transactions) =>
  //     _mapQueryToChartModel(
  //       transactions: transactions,
  //       getDate: (doc) {
  //         final DateTime date = doc.createdAt;
  //         return DateTime(date.year, date.month, date.day);
  //       },
  //       getValue: (doc) =>
  //           doc.isRefunded ? (-(doc.appFee + doc.stripeTax)) : doc.netProfit,
  //     );

  // Future<double> _getTotalRevenue(List<TransactionModel> transactions) async {
  //   double revenue = 0;
  //   for (var e in transactions) {
  //     revenue += (e.isRefunded ? 0 : e.amount);
  //   }
  //   return revenue;
  // }

  // Future<double> _getNetProfit(List<TransactionModel> transactions) async {
  //   double netProfit = 0;
  //   for (var e in transactions) {
  //     netProfit += (e.isRefunded ? (-(e.appFee + e.stripeTax)) : e.netProfit);
  //   }
  //   return netProfit;
  // }

  // Stream<AdminDashboardModel> subscribeShopDashBoardData(
  //     DashboardFilter filter, String shopId) async* {
  //   final String userId = FirebaseAuth.instance.currentUser!.uid;

  //   List<TransactionModel> transactions = await TransactionRepo.instance
  //       .getFilteredTransactionsByShop(filter, userId, shopId);

  //   final List<TransactionModel> paidTransactions = transactions;

  //   final totalTransactions = transactions.length;
  //   final totalRevenue = await _getTotalRevenue(paidTransactions);
  //   final netProfit = await _getNetProfit(paidTransactions);

  //   final transactionsPerDay = await _getTransactionChart(transactions);
  //   final revenuePerDay = await _getRevenueChart(paidTransactions);
  //   final netProfitPerDay = await _getNetProfitChart(paidTransactions);

  //   yield AdminDashboardModel(
  //     totalTransactions: totalTransactions,
  //     totalRevenue: totalRevenue,
  //     netProfit: netProfit,
  //     transactionsPerDay: _mergeValuesOfSimilarDate(transactionsPerDay),
  //     revenuePerDay: _mergeValuesOfSimilarDate(revenuePerDay),
  //     netProfitPerDay: _mergeValuesOfSimilarDate(netProfitPerDay),
  //   );
  // }

  /// Admin Dashboard Data
  Future<AdminDashboardModel> subscribeAdminDashboardData(
      DashboardFilter filter) async {
    // final String userId = FirebaseAuth.instance.currentUser!.uid;

    // List<TransactionModel> transactions = await TransactionRepo.instance
    //     .getFilteredTransactionsByMerchant(filter, userId);

    // final List<TransactionModel> paidTransactions = transactions;

    // // transactions.where((element) => !element.isRefunded).toList();

    // final totalTransactions = transactions.length;
    // final totalRevenue = await _getTotalRevenue(paidTransactions);
    // final netProfit = await _getNetProfit(paidTransactions);

    // final transactionsPerDay = await _getTransactionChart(transactions);
    // final revenuePerDay = await _getRevenueChart(paidTransactions);
    // final netProfitPerDay = await _getNetProfitChart(paidTransactions);

    // return AdminDashboardModel(
    //   totalTransactions: totalTransactions,
    //   totalRevenue: totalRevenue,
    //   netProfit: netProfit,
    //   transactionsPerDay: _mergeValuesOfSimilarDate(transactionsPerDay),
    //   revenuePerDay: _mergeValuesOfSimilarDate(revenuePerDay),
    //   netProfitPerDay: _mergeValuesOfSimilarDate(netProfitPerDay),
    // );

    final AdminDashboardModel dummyData = AdminDashboardModel(
      totalSearches: Random().nextInt(1000) + 100,
      totalUsers: Random().nextInt(1000) + 100,
      searchesPerDay: ChartDataModel.generateRandomData(7),
      usersPerDay: ChartDataModel.generateRandomData(7),
    );
    return dummyData;

    // return AdminDashboardModel(
    //   searchesPerDay: [],
    //   totalSearches: 0,
    //   totalUsers: 0,
    //   usersPerDay: [],
    // );
  }
}
