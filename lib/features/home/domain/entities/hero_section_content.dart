import 'package:flutter/foundation.dart';

@immutable
class HeroSectionContent {
  const HeroSectionContent({
    required this.bioText,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.heroGifAssetPath,
  });

  final String bioText;
  final String githubUrl;
  final String linkedinUrl;
  final String heroGifAssetPath;
}

