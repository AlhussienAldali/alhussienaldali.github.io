import 'package:flutter/foundation.dart';

@immutable
class ContactLinks {
  const ContactLinks({
    required this.email,
    required this.linkedinUrl,
    required this.githubUrl,
    this.phoneTel,
    required this.cvBundledAssetPath,
  });

  final String email;
  final String linkedinUrl;
  final String githubUrl;

  /// Optional `tel:+40...` URI (no spaces).
  final String? phoneTel;

  /// Bundled PDF path in `pubspec.yaml` assets (e.g. `assets/cv/...pdf`).
  final String cvBundledAssetPath;
}
