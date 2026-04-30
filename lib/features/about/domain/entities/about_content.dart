import 'package:flutter/foundation.dart';

import 'experience_item.dart';

@immutable
class AboutContent {
  const AboutContent({
    required this.title,
    required this.headline,
    required this.summary,
    required this.techStack,
    required this.softSkills,
    required this.experience,
    required this.education,
    required this.awards,
    required this.languages,
  });

  final String title;
  final String headline;
  final String summary;

  /// Strong technical tags (stack keywords from CV).
  final List<String> techStack;

  final List<String> softSkills;
  final List<ExperienceItem> experience;
  final List<String> education;
  final List<String> awards;
  final List<String> languages;
}
