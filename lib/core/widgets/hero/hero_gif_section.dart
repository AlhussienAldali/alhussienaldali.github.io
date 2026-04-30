import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

/// Centered hero GIF; frame uses deep palette so edges blend into the page gradient.
class HeroGifSection extends StatelessWidget {
  const HeroGifSection({
    super.key,
    required this.maxHeight,
    required this.assetPath,
  });

  final double maxHeight;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.lerp(AppColors.deep1, AppColors.deep3, 0.5)!
                    .withValues(alpha: 0.55),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deep1.withValues(alpha: 0.9),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.deep2.withValues(alpha: 0.35),
                  blurRadius: 48,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Add your GIF at:\n$assetPath',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

