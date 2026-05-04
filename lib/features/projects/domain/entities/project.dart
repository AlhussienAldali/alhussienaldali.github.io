import 'package:flutter/foundation.dart';

@immutable
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.tech,
    this.bannerAssetPath,
    this.webUrl,
    this.githubUrl,
    this.liveDemoUrl,
  });

  final String title;
  final String description;
  final List<String> tech;

  /// Decorative banner (`assets/images/...`) shown at the top of the card.
  final String? bannerAssetPath;

  /// Primary public link (product site, store listing, or live build).
  final String? webUrl;
  final String? githubUrl;
  final String? liveDemoUrl;

  /// Best URL to open when the user taps the card (prefers site/app over repo).
  String? get primaryLaunchUrl => webUrl ?? liveDemoUrl ?? githubUrl;
}

