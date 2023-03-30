// import '../model/admin_dashboard_model.dart';
// import '../model/enum/dashboard_filter_enum.dart';
// import 'package:flutter/foundation.dart';

// import '../repo/dashboard_repo.dart';

// class DashboardState extends ChangeNotifier {
//   DashboardFilter _currentFilter = DashboardFilter.thisWeek;
//   DashboardFilter get currentFilter => _currentFilter;
//   set currentFilter(DashboardFilter filter) {
//     _currentFilter = filter;
//     notifyListeners();
//   }

//   AdminDashboardModel _dashboardData = AdminDashboardModel(
//       searchesPerDay: [], usersPerDay: [], totalUsers: 0, totalSearches: 0);

//   AdminDashboardModel get dashboardData => _dashboardData;

//   set dashboardData(AdminDashboardModel model) {
//     _dashboardData = model;
//     notifyListeners();
//   }

//   Future<void> loadData() async {
//     isLoading = true;
//     final AdminDashboardModel data = await AdminDashboardRepo.instance
//         .subscribeAdminDashboardData(_currentFilter);

//     dashboardData = data;
//     isLoading = false;
//   }
// }
