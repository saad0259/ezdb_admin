import 'package:flutter/material.dart';

import 'state/theme_state.dart';

ThemeData getTheme(ThemeState themeState) {
  return ThemeData(
    primarySwatch: const MaterialColor(0xffbf1e2e, <int, Color>{
      50: Color(0xfffce4e5),
      100: Color(0xfffcc2c4),
      200: Color(0xfffa99a0),
      300: Color(0xfff86c76),
      400: Color(0xfff54e5c),
      500: Color(0xffbf1e2e),
      600: Color(0xffa31b2a),
      700: Color(0xff871728),
      800: Color(0xff6b1224),
      900: Color(0xff4f0d1f),
    }),
    brightness: themeState.darkTheme ? Brightness.dark : Brightness.light,
    fontFamily: 'Montserrat',
    // scaffoldBackgroundColor: Colors.white,
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.white,
    //   foregroundColor: Colors.black,
    //   titleTextStyle: TextStyle(
    //     color: Colors.black,
    //     fontSize: 20,
    //     fontWeight: FontWeight.normal,
    //   ),
    // ),
    // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    //   backgroundColor: Colors.white,
    //   selectedItemColor: Color(0xffbf1e2e),
    //   unselectedItemColor: Colors.black,
    //   unselectedIconTheme: IconThemeData(
    //     color: Colors.black,
    //     size: 30,
    //   ),
    //   selectedIconTheme: IconThemeData(
    //     color: Color(0xffbf1e2e),
    //     size: 30,
    //   ),
    //   selectedLabelStyle: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.normal,
    //   ),
    //   unselectedLabelStyle: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.normal,
    //   ),
    // ),
    // // inputDecorationTheme: InputDecorationTheme(
    // //   border: OutlineInputBorder(
    // //     borderRadius: BorderRadius.circular(50),
    // //   ),
    // // ),
    // dropdownMenuTheme: DropdownMenuThemeData(
    //   menuStyle: MenuStyle(
    //     surfaceTintColor: MaterialStateProperty.all(Colors.white),
    //     backgroundColor: MaterialStateProperty.all(Colors.white),
    //     side: MaterialStateProperty.all(
    //       const BorderSide(
    //         color: Colors.transparent,
    //       ),
    //     ),
    //     shape: MaterialStateProperty.all(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //     ),
    //   ),
    //   inputDecorationTheme: InputDecorationTheme(
    //     fillColor: Colors.white,
    //     filled: true,
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //   ),
    // ),
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
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 50,
    //       vertical: 20,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(50),
    //       side: const BorderSide(
    //         color: Colors.black,
    //       ),
    //     ),
    //   ),
    // ),
  );
}
