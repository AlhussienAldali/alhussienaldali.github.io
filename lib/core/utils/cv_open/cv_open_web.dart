import 'package:url_launcher/url_launcher.dart';

/// Opens a bundled asset PDF in the browser (Flutter Web).
Future<bool> openBundledCvPdf(String assetPath) async {
  // On Flutter Web, bundled assets are served under the `/assets/` prefix.
  // Example: `assets/cv/file.pdf` becomes available at `.../assets/assets/cv/file.pdf`.
  // Also, GitHub Pages serves the app under `/<repo>/`, so we must resolve
  // against the current base URI (not the origin).
  final normalized = assetPath.startsWith('/') ? assetPath.substring(1) : assetPath;
  final uri = Uri.base.replace(fragment: '').resolve('assets/$normalized');
  return launchUrl(uri, webOnlyWindowName: '_blank');
}
