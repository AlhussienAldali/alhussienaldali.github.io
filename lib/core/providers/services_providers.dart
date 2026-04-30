import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/url_launcher_service.dart';

/// Core services used across features.
final urlLauncherServiceProvider = Provider<UrlLauncherService>((ref) {
  return UrlLauncherServiceImpl();
});

