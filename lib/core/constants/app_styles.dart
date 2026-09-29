import 'package:flutter/material.dart';

/// AppStyles holds design system dimensions, padding, border radiuses,
/// and reusable shadow definitions.
abstract class AppStyles {
  // Spacing & Padding
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 18.0;
  static const double radiusXl = 26.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);

  // Card Elevation & Shadows
  static const List<BoxShadow> cardShadowLight = [
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardShadowDark = [
    BoxShadow(
      color: Color(0x30000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> fintechCardShadow = [
    BoxShadow(
      color: Color(0x33312E81),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> glowGlacier = [
    BoxShadow(
      color: Color(0x3306B6D4),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
