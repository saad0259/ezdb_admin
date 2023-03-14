import 'package:flutter/cupertino.dart';

const rTabletWidth = 800.0;
const rLaptopWidth = 1024.0;
const rLargeLaptopWidth = 1440.0;

const rMinHeight = 720.0;

extension MediaQueryExtended on MediaQueryData {
  bool get isTablet => size.width < rLaptopWidth;

  bool get isLaptop =>
      size.width >= rLaptopWidth && size.width < rLargeLaptopWidth;

  bool get isLargeLaptop => size.width >= rLargeLaptopWidth;

  double getResponsiveHorizontalPadding() {
    return isTablet
        ? 16
        : isLaptop
            ? (rLaptopWidth - rTabletWidth) / 2
            : (rLargeLaptopWidth - rLaptopWidth) / 2;
  }
}

bool get responsiveQueryImport => true;
