import 'package:flutter/material.dart';
import 'package:image_loader/features/random_image/ui/random_image_screen.dart';
import 'package:image_loader/utils/app_visual_theme.dart';

void main() {
  runApp(const MyApp());
}

///Root app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          secondary: Colors.black,
        ),
        extensions: const [
          AppVisualTheme(
            borderColor: Colors.white,
            glowOpacity: 0.5,
            overlayOpacity: 0.08,
            glowColor: Colors.orange,
            backGroundColor: Colors.white,
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          secondary: Colors.white,
          brightness: Brightness.dark,
        ),
        extensions: const [
          AppVisualTheme(
            borderColor: Colors.black,
            glowOpacity: 0.7,
            overlayOpacity: 0.12,
            glowColor: Colors.orange,
            backGroundColor: Colors.black,
          ),
        ],
      ),

      home: const RandomImageScreen(),
    );
  }
}
