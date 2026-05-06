import 'package:image_loader/constants.dart';
import 'package:image_loader/services/network_services.dart';

/// Repo made for fetching the image through the api, cache, ...etc
class ImageRepository {
  final NetworkService _networkService;

  ImageRepository({NetworkService? networkService})
    : _networkService = networkService ?? NetworkService();

  /// Fetches a random image URL from the API.
  ///
  /// Throws an [Exception] if the request fails or the response is invalid.
  Future<String> fetchFromApi() async {
    final response = await _networkService.get<Map<String, dynamic>>(imageApi);

    final data = response.data;

    /// I read the attribute directly for simplicity,
    /// it should have a model with a method to read it from Json
    if (data == null || data['url'] == null) {
      throw Exception(imageExceptionMessage);
    }

    return data['url'] as String;
  }
}
