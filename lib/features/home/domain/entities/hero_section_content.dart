import 'package:flutter/foundation.dart';

@immutable
class HeroSectionContent {
  const HeroSectionContent({
    required this.bioText,
    required this.githubUrl,
    required this.liveDemoUrl,
    required this.heroGifAssetPath,
  });

  final String bioText;
  final String githubUrl;
  final String liveDemoUrl;
  final String heroGifAssetPath;
}

