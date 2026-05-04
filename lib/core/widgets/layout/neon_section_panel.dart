import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

/// A bordered surface with a top banner image and typography tuned for readability.
class NeonSectionPanel extends StatelessWidget {
  const NeonSectionPanel({
    super.key,
    required this.assetPath,
    required this.title,
    required this.child,
    this.eyebrow,
    this.isMobile = false,
    this.childTopSpacing = 16,
    this.bannerAspectRatio = 960 / 220,
  });

  final String assetPath;
  final String title;
  final String? eyebrow;
  final Widget child;
  final bool isMobile;
  final double childTopSpacing;
  final double bannerAspectRatio;

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.orbitron(
      fontSize: isMobile ? 17 : 19,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.4,
      color: Colors.white,
      height: 1.25,
    );
    final eyebrowStyle = GoogleFonts.orbitron(
      fontSize: isMobile ? 11.5 : 12.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: AppColors.cyan.withValues(alpha: 0.9),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.deep3.withValues(alpha: 0.72),
          width: 1,
        ),
        color: AppColors.surface.withValues(alpha: 0.42),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: bannerAspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.deep2.withValues(alpha: 0.85),
                              AppColors.surface,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Image not found:\n$assetPath',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surface.withValues(alpha: 0.35),
                          AppColors.surface.withValues(alpha: 0.72),
                        ],
                        stops: const [0.35, 0.78, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 22,
                18,
                isMobile ? 16 : 22,
                isMobile ? 18 : 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null) ...[
                    Text(eyebrow!.toUpperCase(), style: eyebrowStyle),
                    const SizedBox(height: 8),
                  ],
                  Text(title, style: titleStyle),
                  Container(
                    margin: EdgeInsets.only(top: isMobile ? 10 : 12, bottom: 0),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.cyan.withValues(alpha: 0.22),
                          AppColors.orange.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: childTopSpacing),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
