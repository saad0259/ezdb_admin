import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/login_view.dart';
import '../model/admin_model.dart';
import '../repo/auth_repo.dart';
import '../state/auth_state.dart';
import '../state/navigator_state.dart';
import 'delete_user/delete_user.dart';
import 'navigator_view.dart';
import 'privacy_policy.dart';
import 'splash_view.dart';

final routeBuilder = RoutesLocationBuilder(
  routes: {
    '/': (context, state, data) => const BeamPage(
        key: ValueKey('Home'),
        title: 'ezDB Admin',
        child: NavigatorViewWidget()),
    '/removeAccount': (context, state, data) => const BeamPage(
        key: ValueKey('DeleteUserScreen'),
        title: 'ezDB',
        child: DeleteUserScreen()),
    '/privacy-policy': (context, state, data) => const BeamPage(
          key: ValueKey('Privacy Policy'),
          title: 'Privacy Policy',
          child: PivacyPolicy(),
        ),
  },
);

class NavigatorViewWidget extends StatelessWidget {
  const NavigatorViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          log('waiting');
          return const SplashView();
        }
        if (!userSnap.hasData) {
          return const LoginView();
        } else {
          return StreamBuilder<AdminModel>(
              stream: AuthRepo.instance.watchAdmin(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final AuthState authState =
                      Provider.of<AuthState>(context, listen: false);
                  authState.admin = snapshot.data;
                  return ChangeNotifierProvider(
                    create: (_) => NavState(),
                    child: const NavigatorView(),
                  );
                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                }
                log('no data: waiting');
                return const SplashView();
              });
        }
      },
    );
  }
}
