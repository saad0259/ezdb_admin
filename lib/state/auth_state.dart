import 'package:flutter/foundation.dart';

import '../model/admin_model.dart';

class AuthState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AdminModel? _admin;
  AdminModel? get admin => _admin;
  set admin(AdminModel? value) {
    _admin = value;
    notifyListeners();
  }
}
