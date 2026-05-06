import 'package:flutter/foundation.dart';

@immutable
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.tech,
    this.bannerImageUrl,
    this.bannerAssetPath,
    this.webUrl,
    this.githubUrl,
    this.liveDemoUrl,
    this.showcaseImageUrls = const [],
  });

  final String title;
  final String description;
  final List<String> tech;

  /// Remote banner (HTTPS). When set, shown instead of [bannerAssetPath].
  final String? bannerImageUrl;

  /// Decorative banner (`assets/images/...`) when [bannerImageUrl] is null.
  final String? bannerAssetPath;

  /// Primary public link (product site, store listing, or live build).
  final String? webUrl;
  final String? githubUrl;
  final String? liveDemoUrl;

  /// Screenshots / store gallery (HTTPS). When non-empty, shown as carousel above copy.
  final List<String> showcaseImageUrls;

  /// Best URL to open when the user taps the card (prefers site/app over repo).
  String? get primaryLaunchUrl => webUrl ?? liveDemoUrl ?? githubUrl;
}

