import 'package:url_launcher/url_launcher.dart';

/// Opens a bundled asset PDF in the browser (Flutter Web).
Future<bool> openBundledCvPdf(String assetPath) async {
  final uri = Uri.parse('${Uri.base.origin}/$assetPath');
  return launchUrl(uri, webOnlyWindowName: '_blank');
}
