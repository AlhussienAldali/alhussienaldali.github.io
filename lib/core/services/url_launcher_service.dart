import 'package:url_launcher/url_launcher.dart';

/// Abstraction for opening external URLs (tests can inject a fake).
abstract class UrlLauncherService {
  Future<bool> openExternalUri(Uri uri);
}

class UrlLauncherServiceImpl implements UrlLauncherService {
  @override
  Future<bool> openExternalUri(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
