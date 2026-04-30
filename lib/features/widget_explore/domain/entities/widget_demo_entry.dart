import 'package:flutter/foundation.dart';

@immutable
class WidgetDemoEntry {
  const WidgetDemoEntry({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}
