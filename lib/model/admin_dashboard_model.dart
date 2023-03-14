import 'chart_data_model.dart';

class AdminDashboardModel {
  int totalUsers;
  double totalSearches;

  List<ChartDataModel> usersPerDay;
  List<ChartDataModel> searchesPerDay;

  AdminDashboardModel({
    required this.totalUsers,
    required this.totalSearches,
    required this.usersPerDay,
    required this.searchesPerDay,
  });
}
