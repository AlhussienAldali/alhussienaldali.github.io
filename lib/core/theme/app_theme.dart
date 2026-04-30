import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.cyan,
      secondary: AppColors.orange,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.scaffold,
    textTheme: GoogleFonts.montserratTextTheme(),
  );
}
