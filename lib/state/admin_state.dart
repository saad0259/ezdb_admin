import 'package:flutter/foundation.dart';

import '../model/admin_model.dart';
import '../repo/admins_repo.dart';

class AdminState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<AdminModel> _admins = [];
  List<AdminModel> get admins => _admins;
  set admins(List<AdminModel> value) {
    _admins = value;
    notifyListeners();
  }

  Future<void> loadData() async {
    isLoading = true;
    final Stream<List<AdminModel>> streamData =
        AdminRepo.instance.watchAdmins();

    admins = await streamData.first;

    streamData.listen((event) {
      admins = event;
    });
    isLoading = false;
  }

  Future<void> deleteAdmin(String uid) async {
    isLoading = true;
    await AdminRepo.instance.deleteAdmin(uid);
    isLoading = false;
  }

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
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

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<AdminModel> get filteredAdmins {
    List<AdminModel> filteredList = admins;

    filteredList = filteredList
        .where((element) =>
            element.createdAt.isAfter(startDate) &&
            element.createdAt.isBefore(
              endDate.add(const Duration(days: 1)),
            ))
        .toList();

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((element) => element.email.toString().contains(searchQuery))
          .toList();
    }

    return filteredList;
  }

  List<AdminLogs> _logs = [];
  List<AdminLogs> get logs => _logs;
  set logs(List<AdminLogs> value) {
    _logs = value;
    notifyListeners();
  }

  Future<void> loadLogs(String uid) async {
    isLoading = true;
    logs = await AdminRepo.instance.getIndividualAdminLogs(uid);
    isLoading = false;
  }

  String _adminLogsSearchQuery = '';
  String get adminLogsSearchQuery => _adminLogsSearchQuery;
  set adminLogsSearchQuery(String query) {
    _adminLogsSearchQuery = query;
    notifyListeners();
  }

  List<AdminLogs> _allLogs = [];
  List<AdminLogs> get allLogs {
    List<AdminLogs> filteredList = _allLogs;

    if (adminLogsSearchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((element) =>
              element.email.toString().contains(adminLogsSearchQuery) ||
              element.contents.contains(adminLogsSearchQuery))
          .toList();
    }

    return filteredList;
  }

  set allLogs(List<AdminLogs> value) {
    _allLogs = value;
  }

  Future<void> loadAllLogs() async {
    isLoading = true;
    allLogs = await AdminRepo.instance.getAllLogs();
    isLoading = false;
  }
}
