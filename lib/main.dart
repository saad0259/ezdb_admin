import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view/route_generator.dart';
import 'firebase_options.dart';
import 'state/navigator_state.dart';
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
      ],
      child: Consumer<ThemeState>(
        builder: (context, themeState, child) {
          return Builder(
            builder: (context) => MaterialApp.router(
              scrollBehavior: MyCustomScrollBehavior(),
              title: 'Mega Admin',
              debugShowCheckedModeBanner: false,
              routerDelegate: routerDelegate,
              routeInformationParser: BeamerParser(),
              theme: ThemeData(
                brightness:
                    themeState.darkTheme ? Brightness.dark : Brightness.light,
                primarySwatch: const MaterialColor(0xFFd61f5d, <int, Color>{
                  50: Color(0xFFfbe9ef),
                  100: Color(0xFFf7d2df),
                  200: Color(0xFFf3bcce),
                  300: Color(0xFFefa5be),
                  400: Color(0xFFeb8fae),
                  500: Color(0xFFe6799e),
                  600: Color(0xFFe2628e),
                  700: Color(0xFFde4c7d),
                  800: Color(0xFFda356d),
                  900: Color(0xFFd61f5d),
                }),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(180, 48),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
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
