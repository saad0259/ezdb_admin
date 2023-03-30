import 'chart_data_model.dart';

class AdminDashboardModel {
  int totalUsers;
  int totalSearches;

  List<ChartDataModel> usersPerDay;
  List<ChartDataModel> searchesPerDay;

  AdminDashboardModel({
    required this.totalUsers,
    required this.totalSearches,
    required this.usersPerDay,
    required this.searchesPerDay,
  });
}
