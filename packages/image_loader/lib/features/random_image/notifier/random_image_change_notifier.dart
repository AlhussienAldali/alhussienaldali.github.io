import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_loader/constants.dart';

import 'package:image_loader/features/random_image/repo/image_repository.dart';
import 'package:image_loader/utils/color_helper.dart';

/// A controller responsible for managing the UI state of the random image screen.
///
/// `ChangeNotifier` is used to encapsulate screen-specific state and side effects
/// (loading, error handling, image fetching, and background color updates),
/// keeping the UI declarative and the architecture intentionally minimal.
class RandomImageChangeNotifier extends ChangeNotifier {
  RandomImageChangeNotifier(this._repository);

  final ImageRepository _repository;

  String? imageUrl;
  Color backgroundColor = Colors.black;
  bool isLoading = false;
  String? errorMessage;

  ///Load the link of the image from the UI and then return it
  ///Also calculate the background color
  Future<void> loadImage() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final sw = Stopwatch()..start();
    try {
      final url = await _repository.fetchFromApi();
      imageUrl = url;

      // Fetch image bytes for color extraction
      final response = await http.get(Uri.parse(url));
      // Color calculation is part of loading
      await _updateBackgroundColor(response.bodyBytes);

      await _waitRemainingLoaderTime(sw.elapsed);
      isLoading = false;
      notifyListeners();
    } catch (_) {
      await _waitRemainingLoaderTime(sw.elapsed);
      isLoading = false;
      errorMessage = imageExceptionMessage;
      notifyListeners();
    }
  }

  Future<void> _waitRemainingLoaderTime(Duration elapsed) async {
    final remaining = minLogoLoaderVisibleDuration - elapsed;
    if (!remaining.isNegative) {
      await Future<void>.delayed(remaining);
    }
  }

  Future<void> _updateBackgroundColor(Uint8List imageBytes) async {
    final color = await extractDominantColor(imageBytes);
    backgroundColor = color;
  }
}
