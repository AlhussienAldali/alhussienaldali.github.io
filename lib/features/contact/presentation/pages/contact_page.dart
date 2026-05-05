import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cv_open/cv_open.dart';
import '../providers/contact_providers.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(contactLinksProvider);

    Future<void> openUrl(String url) async {
      final messenger = ScaffoldMessenger.of(context);
      final launcher = ref.read(urlLauncherServiceProvider);
      final ok = await launcher.openExternalUri(Uri.parse(url));
      if (!ok) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not open: $url')),
        );
      }
    }

    Future<void> openCv() async {
      final messenger = ScaffoldMessenger.of(context);
      final ok = await openBundledCvPdf(links.cvBundledAssetPath);
      if (!ok) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not open CV PDF')),
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < Breakpoints.mobile;
        final isTablet = w >= Breakpoints.mobile && w < Breakpoints.tablet;
        final horizontal = isMobile ? 18.0 : (isTablet ? 28.0 : 40.0);
        final maxWidth = isMobile ? double.infinity : 720.0;

        final tiles = <_ContactTileData>[
          _ContactTileData(
            label: 'Email',
            icon: Icons.email_rounded,
            accent: AppColors.cyan,
            onTap: () => openUrl(links.email),
          ),
          _ContactTileData(
            label: 'LinkedIn',
            icon: Icons.work_rounded,
            accent: AppColors.orange,
            onTap: () => openUrl(links.linkedinUrl),
          ),
          _ContactTileData(
            label: 'GitHub',
            icon: Icons.code_rounded,
            accent: AppColors.cyan,
            onTap: () => openUrl(links.githubUrl),
          ),
          if (links.phoneTel != null)
            _ContactTileData(
              label: 'Phone',
              icon: Icons.phone_rounded,
              accent: AppColors.orange,
              onTap: () => openUrl(links.phoneTel!),
            ),
          _ContactTileData(
            label: 'CV PDF',
            icon: Icons.description_rounded,
            accent: AppColors.orange,
            onTap: openCv,
          ),
        ];

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 40,
                    child: IgnorePointer(
                      child: _SignalRings(
                        size: isMobile ? 320 : 400,
                        opacity: 0.22,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.cyan.withValues(alpha: 0.35),
                              AppColors.orange.withValues(alpha: 0.28),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.2),
                              blurRadius: 28,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'AA',
                            style: GoogleFonts.orbitron(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'OPEN CHANNEL',
                        style: GoogleFonts.orbitron(
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w800,
                          color: AppColors.cyan.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contact',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 28 : 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Romania · Bucharest · Remote-friendly.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: isMobile ? 15 : 16.5,
                          height: 1.55,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      const SizedBox(height: 28),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          color: AppColors.surface.withValues(alpha: 0.42),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            isMobile ? 14 : 18,
                            18,
                            isMobile ? 14 : 18,
                            20,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tiles.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 2 : 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: isMobile ? 1.05 : 1.12,
                            ),
                            itemBuilder: (context, i) =>
                                _ContactTile(data: tiles[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContactTileData {
  const _ContactTileData({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.data});

  final _ContactTileData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: data.accent.withValues(alpha: 0.28),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                data.accent.withValues(alpha: 0.1),
                AppColors.deep1.withValues(alpha: 0.55),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                size: 28,
                color: data.accent.withValues(alpha: 0.95),
              ),
              const SizedBox(height: 10),
              Text(
                data.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalRings extends StatelessWidget {
  const _SignalRings({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SignalRingsPainter(opacity: opacity),
      ),
    );
  }
}

class _SignalRingsPainter extends CustomPainter {
  _SignalRingsPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide / 2;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < 5; i++) {
      final t = (i + 1) / 5;
      p.color = Color.lerp(
        AppColors.cyan,
        AppColors.orange,
        t * 0.85,
      )!.withValues(alpha: opacity * (1 - t * 0.35));
      canvas.drawCircle(c, maxR * t, p);
    }
  }

  @override
  bool shouldRepaint(covariant _SignalRingsPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
