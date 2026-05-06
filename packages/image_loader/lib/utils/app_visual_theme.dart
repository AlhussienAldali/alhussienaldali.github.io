import 'dart:ui';

import 'package:flutter/material.dart';

/// Theme color class for dark and light mode
@immutable
class AppVisualTheme extends ThemeExtension<AppVisualTheme> {
  final Color borderColor;
  final double glowOpacity;
  final double overlayOpacity;
  final Color glowColor;
  final Color backGroundColor;

  const AppVisualTheme({
    required this.borderColor,
    required this.glowOpacity,
    required this.overlayOpacity,
    required this.glowColor,
    required this.backGroundColor,
  });

  @override
  AppVisualTheme copyWith({
    Color? borderColor,

    double? glowOpacity,
    double? overlayOpacity,
    Color? glowColor,
    Color? backGroundColor,
  }) {
    return AppVisualTheme(
      borderColor: borderColor ?? this.borderColor,
      glowOpacity: glowOpacity ?? this.glowOpacity,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      glowColor: glowColor ?? this.glowColor,
      backGroundColor: backGroundColor ?? this.backGroundColor,
    );
  }

  @override
  AppVisualTheme lerp(ThemeExtension<AppVisualTheme>? other, double t) {
    if (other is! AppVisualTheme) {
      return this;
    }
    return AppVisualTheme(
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      glowOpacity: lerpDouble(glowOpacity, other.glowOpacity, t)!,
      overlayOpacity: lerpDouble(overlayOpacity, other.overlayOpacity, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      backGroundColor: Color.lerp(backGroundColor, other.backGroundColor, t)!,
    );
  }
}
