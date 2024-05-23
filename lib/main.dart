import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view/route_generator.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'state/admin_state.dart';
import 'state/allowed_users_state.dart';
import 'state/auth_state.dart';
import 'state/navigator_state.dart';
import 'state/settings_state.dart';
import 'state/theme_state.dart';
import 'state/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(App());
}

class App extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    locationBuilder: routeBuilder,
  );

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => NavState()),
        ChangeNotifierProvider(create: (_) => ThemeState()),
        ChangeNotifierProvider(create: (_) => SettingsState()),
        ChangeNotifierProvider(create: (_) => AdminState()),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => AllowedUsersState()),
        // ChangeNotifierProvider(create: (_) => DashboardState()),
      ],
      child: Consumer<ThemeState>(
        builder: (context, themeState, child) {
          return Builder(
            builder: (context) => MaterialApp.router(
              scrollBehavior: MyCustomScrollBehavior(),
              title: 'ezDB Admin',
              debugShowCheckedModeBanner: false,
              routerDelegate: routerDelegate,
              routeInformationParser: BeamerParser(),
              theme: getTheme(themeState),
              // theme: ThemeData(
              //   brightness:
              //       themeState.darkTheme ? Brightness.dark : Brightness.light,
              //   primarySwatch: const MaterialColor(0xffbf1e2e, <int, Color>{
              //     50: Color(0xfffce4e5),
              //     100: Color(0xfffcc2c4),
              //     200: Color(0xfffa99a0),
              //     300: Color(0xfff86c76),
              //     400: Color(0xfff54e5c),
              //     500: Color(0xffbf1e2e),
              //     600: Color(0xffa31b2a),
              //     700: Color(0xff871728),
              //     800: Color(0xff6b1224),
              //     900: Color(0xff4f0d1f),
              //   }),
              //   elevatedButtonTheme: ElevatedButtonThemeData(
              //     style: ElevatedButton.styleFrom(
              //       minimumSize: const Size(180, 48),
              //       padding: const EdgeInsets.symmetric(vertical: 20),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(24),
              //       ),
              //     ),
              //   ),
              //   inputDecorationTheme: InputDecorationTheme(
              //     isDense: true,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
            ),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
