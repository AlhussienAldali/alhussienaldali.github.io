import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'app_visual_theme.dart';

/// Displays a cached remote image with a lightweight loading indicator.
///
/// We intentionally keep this widget stateless and UI-only so that
/// image fetching and error handling remain outside the view layer.

class RemoteImage extends StatelessWidget {
  /// image link provided as a string
  final String imageUrl;

  /// Size of the widget, by default 240
  final double? size;

  /// widget constructor
  const RemoteImage({super.key, required this.imageUrl, this.size});

  @override
  Widget build(BuildContext context) {
    final double dimension = size ?? 240;
    final visuals = Theme.of(context).extension<AppVisualTheme>()!;

    final double radius = 16;

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),

        border: Border.all(color: visuals.borderColor, width: 2),

        boxShadow: [
          BoxShadow(
            color: visuals.borderColor.withAlpha(
              (visuals.glowOpacity * 255).round(),
            ),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 500),
          errorWidget: (_, _, _) =>
              const Center(child: Icon(Icons.broken_image, size: 40)),
        ),
      ),
    );
  }
}
