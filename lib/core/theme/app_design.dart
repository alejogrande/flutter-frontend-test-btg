import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const SizedBox vxs = SizedBox(height: xs);
  static const SizedBox vsm = SizedBox(height: sm);
  static const SizedBox vmd = SizedBox(height: md);
  static const SizedBox vlg = SizedBox(height: lg);
  static const SizedBox vxl = SizedBox(height: xl);

  static const SizedBox hsm = SizedBox(width: sm);
  static const SizedBox hmd = SizedBox(width: md);
  static const SizedBox hlg = SizedBox(width: lg);

  static const double maxContentWidth = 1300.0;
  static const double mobileBreakpoint = 500.0;
}

class AppRadius {
  static const double lg = 20.0;
  static const double xl = 24.0;
  static BorderRadius roundedLg = BorderRadius.circular(lg);
  static BorderRadius roundedXl = BorderRadius.circular(xl);
}