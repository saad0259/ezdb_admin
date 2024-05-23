import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../repo/allowed_users_repo.dart';

class AllowedUsersState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<String> _allowedUsers = [];
  List<String> get allowedUsers => _allowedUsers.where((element) {
        return element.contains(_searchQuery);
      }).toList();

  set allowedUsers(List<String> value) {
    _allowedUsers = value;
    notifyListeners();
  }

  Future<void> loadData() async {
    try {
      isLoading = true;
      allowedUsers = await AllowedUsersRepo.instance.getAllowedUsers();
    } catch (e) {
      log('error loading allowed users: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> addAllowedUser(String phone) async {
    try {
      await AllowedUsersRepo.instance.addAllowedUser(phone);
    } catch (e) {
      debugPrint('error adding user to allowed list: $e');
      rethrow;
    }
  }

  Future<void> deleteAllowedUser(String phone) async {
    try {
      await AllowedUsersRepo.instance.removeAllowedUser(phone);
    } catch (e) {
      log('error deleting user from allowed list: $e');
      rethrow;
    }
  }
}
