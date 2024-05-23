import 'package:flutter/material.dart';

import 'state/theme_state.dart';

ThemeData getTheme(ThemeState themeState) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xffff7518),
      primary: const Color(0xffff7518),
      brightness: themeState.darkTheme ? Brightness.dark : Brightness.light,
    ),

    useMaterial3: false,
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

extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  InputDecorationTheme get inputDecorationTheme =>
      Theme.of(this).inputDecorationTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  double get rTabletWidth => 800.0;
  double get rLaptopWidth => 1024.0;
  double get rLargeLaptopWidth => 1440.0;
  double get rMinHeight => 720.0;

  bool get isTablet => width < rLaptopWidth;

  bool get isLaptop => width >= rLaptopWidth && width < rLargeLaptopWidth;

  bool get isLargeLaptop => width >= rLargeLaptopWidth;

  double getResponsiveHorizontalPadding() {
    return isTablet
        ? 16
        : isLaptop
            ? (rLaptopWidth - rTabletWidth) / 2
            : (rLargeLaptopWidth - rLaptopWidth) / 2;
  }

  double getResponsiveWidth() {
    return isTablet
        ? rTabletWidth
        : isLaptop
            ? rLaptopWidth
            : rLargeLaptopWidth;
  }
}
