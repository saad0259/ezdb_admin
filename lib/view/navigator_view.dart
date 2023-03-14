import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../contants/app_images.dart';
import '../model/navigator_model.dart';
import '../state/navigator_state.dart';
import '../state/theme_state.dart';
import '../view/responsive/extended_media_query.dart';
import '../view/responsive/responsive_layout.dart';
import 'dashboard/admin_dashboard_view.dart';
import 'users/users_list_view.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({Key? key}) : super(key: key);

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    return ResponsiveHeightLayout(
      child: Scaffold(
        body: Row(
          children: [
            if (!query.isTablet)
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(right: 1),
                child: getDrawer(context),
              ),
            Expanded(
              child: Consumer<NavState>(
                builder: (context, navState, child) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Row(
                        children: [
                          if (navState.canPop())
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => navState.pop(),
                              icon: const Icon(Icons.arrow_back),
                            ),
                          if (navState.canPop()) const SizedBox(width: 10),
                          Text(navState.active.title),
                        ],
                      ),
                      elevation: 2,
                      actions: [
                        Consumer<ThemeState>(
                          builder: (context, themeState, child) {
                            return IconButton(
                              icon: themeState.darkTheme
                                  ? const Icon(Icons.brightness_7)
                                  : const Icon(Icons.brightness_3_outlined),
                              onPressed: () {
                                themeState.switchDarkTheme();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    drawer: query.isTablet
                        ? navState.canPop()
                            ? null
                            : getDrawer(context)
                        : null,
                    body: navState.active.widget,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDrawer(BuildContext context) {
    final NavState navState = Provider.of<NavState>(context, listen: false);

    return Drawer(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AppImages.transparentLogo,
                  width: 100,
                ),
              ),
            ),
            const Divider(height: 0),
            NavButton(
              title: 'Dashboard',
              icon: Icons.dashboard,
              onTap: () => navState.activate(
                NavigatorModel('Dashboard', const AdminDashboardView()),
              ),
            ),
            NavButton(
              title: "Users",
              icon: Icons.receipt,
              onTap: () => navState.activate(
                NavigatorModel("Users", const UsersListView()),
              ),
            ),
            NavButton(
              title: 'Logout',
              icon: Icons.exit_to_app_outlined,
              onTap: () async {
                final ThemeState themeState =
                    Provider.of<ThemeState>(context, listen: false);
                await FirebaseAuth.instance.signOut();
                await themeState.reset();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  final String title;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavState>(
      builder: (context, navState, child) {
        return ListTile(
          selected: navState.active.title == title,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          leading: Icon(icon, size: 24),
          title: Text(title),
          onTap: onTap,
        );
      },
    );
  }
}
