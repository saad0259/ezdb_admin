import 'package:flutter/cupertino.dart';

import '../model/navigator_model.dart';
import '../view/dashboard/admin_dashboard_view.dart';

class NavState extends ChangeNotifier {
  static final defaultNav = NavigatorModel(
    'Dashboard',
    const AdminDashboardView(),
    // 'Settings',
    // const SettingsView(),
  );

  NavigatorModel active = defaultNav;
  List<NavigatorModel> navigationStack = [defaultNav];

  void activate(NavigatorModel model, {bool root = true}) {
    if (root) {
      navigationStack.removeLast();
      navigationStack.add(model);
    } else {
      navigationStack.add(model);
    }
    active = model;
    notifyListeners();
  }

  void pop() {
    if (navigationStack.isNotEmpty) {
      navigationStack.removeLast();
      if (navigationStack.isNotEmpty) {
        active = navigationStack.last;
      } else {
        active = defaultNav;
      }
    }
    notifyListeners();
  }

  bool canPop() {
    return navigationStack.length > 1;
  }
}
