import 'dart:developer';

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
    log('length: ${admins.length}');
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
}
