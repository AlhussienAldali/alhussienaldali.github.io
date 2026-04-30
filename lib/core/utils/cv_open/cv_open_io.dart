import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Copies a bundled PDF to a temp file and opens it (mobile / desktop).
Future<bool> openBundledCvPdf(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/portfolio_cv.pdf');
  await file.writeAsBytes(bytes, flush: true);
  final uri = Uri.file(file.path);
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
