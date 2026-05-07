import 'package:url_launcher/url_launcher.dart';

/// Opens a bundled asset PDF in the browser (Flutter Web).
Future<bool> openBundledCvPdf(String assetPath) async {
  // IMPORTANT: GitHub Pages serves the app under `/<repo>/`.
  // Using `origin + /assets/...` breaks (404). Always resolve against the
  // current base URI (which includes the repo path).
  final uri = Uri.base.resolve(assetPath);
  return launchUrl(uri, webOnlyWindowName: '_blank');
}
