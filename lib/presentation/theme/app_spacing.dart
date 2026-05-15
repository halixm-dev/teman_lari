import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;

  // Edge insets
  static const EdgeInsets cardPadding = EdgeInsets.all(space4);
  static const EdgeInsets pagePadding = EdgeInsets.all(space4);
  static const EdgeInsets pagePaddingWide = EdgeInsets.symmetric(
    horizontal: space6,
    vertical: space4,
  );

  // Radius
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radius2xl = 24;
  static const double radiusFull = 9999;
}
