import 'package:flutter/foundation.dart';

import '../model/admin_dashboard_model.dart';
import '../model/chart_data_model.dart';
import '../model/enum/dashboard_filter_enum.dart';
import '../model/users_model.dart';
import '../repo/auth_repo.dart';

class UserState extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  String searchQuery = '';

  AdminDashboardModel _adminDashboardModel = AdminDashboardModel(
      totalUsers: 0, totalSearches: 0, usersPerDay: [], searchesPerDay: []);

  AdminDashboardModel get adminDashboardModel {
    final List<UserModel> users = adminUsers;
    final List<UserSearch> searches = [];
    for (final UserModel user in users) {
      searches.addAll(user.userSearch);
    }

    _adminDashboardModel = AdminDashboardModel(
      totalUsers: users.length,
      totalSearches: searches.length,
      usersPerDay: _mergeValuesOfSimilarDate(_getUserChart(users)),
      searchesPerDay: _mergeValuesOfSimilarDate(_getSearchChart(searches)),
    );
    return _adminDashboardModel;
  }

  DashboardFilter _currentFilter = DashboardFilter.max;
  DashboardFilter get currentFilter => _currentFilter;
  set currentFilter(DashboardFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 120));
  DateTime get startDate => _startDate;
  set startDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  DateTime _endDate = DateTime.now();
  DateTime get endDate => _endDate;
  set endDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  List<UserModel> _userList = [];
  List<UserModel> get userList => _userList;

  List<UserModel> get adminUsers {
    List<UserModel> filteredList = _userList;

    filteredList = filteredList
        .where((element) =>
            element.createdAt.isAfter(currentFilter.startAt) &&
            element.createdAt.isBefore(currentFilter.endAt))
        .toList();

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((element) =>
              element.createdAt.isAfter(currentFilter.startAt) &&
              element.createdAt.isBefore(currentFilter.endAt))
          .toList();
    }

    return filteredList;
  }

  List<UserModel> get filteredUsers {
    List<UserModel> filteredList = _userList;

    filteredList = filteredList
        .where((element) =>
            element.createdAt.isAfter(startDate) &&
            element.createdAt.isBefore(
              endDate.add(const Duration(days: 1)),
            ) &&
            (element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                element.phone.toString().contains(searchQuery) ||
                element.email.toString().contains(searchQuery)))
        .toList();

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((element) =>
              element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.phone.toString().contains(searchQuery) ||
              element.email.toString().contains(searchQuery))
          .toList();
    }

    return filteredList;
  }

  set userList(List<UserModel> list) {
    _userList = list.where((element) => element.isVerified).toList();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  Future<void> loadUserdata() async {
    final List<UserModel> list = await AuthRepo().getUsers();
    this.userList = list;
    // stream.listen((event) {
    //   this.userList = event;
    // });
  }

  UserModel getUserById(String id) {
    return _userList.firstWhere((element) => element.id == id);
  }

  List<ChartDataModel> _getUserChart(List<UserModel> dataList) =>
      _mapQueryToChartModel(
        dataList: dataList,
        getDate: (doc) {
          final DateTime date = doc.createdAt;
          return DateTime(date.year, date.month, date.day);
        },
        getValue: (doc) => 1,
      );
  List<ChartDataModel> _getSearchChart(List<UserSearch> dataList) =>
      _mapQueryToChartModel(
        dataList: dataList,
        getDate: (doc) {
          final DateTime date = doc.createdAt;
          return DateTime(date.year, date.month, date.day);
        },
        getValue: (doc) => 1,
      );

  List<ChartDataModel> _mapQueryToChartModel<T>({
    required List<T> dataList,
    required DateTime Function(T doc) getDate,
    required double Function(T doc) getValue,
  }) =>
      dataList
          .map((doc) => ChartDataModel(
                getDate(doc),
                getValue(doc),
              ))
          .toList();

  List<ChartDataModel> _mergeValuesOfSimilarDate(List<ChartDataModel> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length; j++) {
        if (list[i].date == list[j].date) {
          list[i].value += list[j].value;
          list.removeAt(j);
          j--;
        }
      }
    }
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }
}
