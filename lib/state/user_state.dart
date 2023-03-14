import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../model/users_model.dart';

class UserState extends ChangeNotifier {
  bool isLoading = false;
  String searchQuery = '';

  DateTime startDate = DateTime.now().subtract(const Duration(days: 70));
  DateTime endDate = DateTime.now();

  List<UserModel> _userList = [];
  List<UserModel> get userList {
    List<UserModel> filteredList = _userList;

    filteredList = filteredList
        .where((element) =>
            element.createdAt.isAfter(startDate) &&
            element.createdAt.isBefore(endDate))
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

  Future<void> loadUsers() async {
    try {
      //todo remove this delay
      await Future.delayed(const Duration(seconds: 2));

      setUserList(UserModel.generateUsers(100));
    } catch (e) {
      log(e.toString());
    }
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setUserList(List<UserModel> list) {
    _userList.clear();
    _userList = list;
    notifyListeners();
  }

  toggleIsLoading() {
    isLoading = !isLoading;
  }

  void setStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }
}
