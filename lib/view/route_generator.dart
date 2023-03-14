import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repo/auth_repo.dart';
import '../state/navigator_state.dart';
import '../util/snippet.dart';
import 'navigator_view.dart';
import 'splash_view.dart';

final routeBuilder = RoutesLocationBuilder(
  routes: {
    '/': (context, state, data) => const BeamPage(
        key: ValueKey('Home'),
        title: 'Mega Admin',
        child: NavigatorViewWidget())
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
          return const SplashView();
        }
        if (!userSnap.hasData) {
          // return const LoginView();
          //!
          return ChangeNotifierProvider(
            create: (_) => NavState(),
            child: const NavigatorView(),
          );
        } else {
          return FutureBuilder<bool>(
              future: AuthRepo.instance.isAdmin(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data! &&
                    userSnap.data!.emailVerified) {
                  return ChangeNotifierProvider(
                    create: (_) => NavState(),
                    child: const NavigatorView(),
                  );
                }
                if (snapshot.hasData && !snapshot.data!) {
                  FirebaseAuth.instance.signOut();
                  snack(context, 'Invalid Credentials');
                }
                if (snapshot.hasData &&
                    snapshot.data! &&
                    !userSnap.data!.emailVerified) {
                  FirebaseAuth.instance.signOut();
                  snack(context, 'Email not verified');
                }

                return const SplashView();
              });
        }
      },
    );
  }
}
