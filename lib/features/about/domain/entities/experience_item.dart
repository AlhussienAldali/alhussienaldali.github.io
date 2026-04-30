import 'package:flutter/foundation.dart';

@immutable
class ExperienceItem {
  const ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.highlights,
  });

  final String role;
  final String company;
  final String period;
  final String location;
  final List<String> highlights;
}
