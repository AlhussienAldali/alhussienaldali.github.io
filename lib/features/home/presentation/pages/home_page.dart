import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/animation_durations.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cv_open/cv_open.dart';
import '../../../../core/widgets/background/animated_gradient_backdrop.dart';
import '../../../../core/widgets/hero/hero_cta_row.dart';
import '../../../../core/widgets/hero/hero_gif_section.dart';
import '../../../../core/widgets/hero/typing_bio_display.dart';
import '../providers/home_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late final AnimationController _gradientController;
  late final AnimationController _bioEntranceController;
  late final AnimationController _buttonsEntranceController;

  late final Animation<double> _bioFade;
  late final Animation<Offset> _bioSlide;
  late final Animation<double> _buttonsFade;
  late final Animation<Offset> _buttonsSlide;

  Timer? _typingTimer;
  int _typedLength = 0;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      vsync: this,
      duration: AnimationDurations.gradientCycle,
    )..repeat(reverse: true);

    _bioEntranceController = AnimationController(
      vsync: this,
      duration: AnimationDurations.bioEntrance,
    );
    _bioFade = CurvedAnimation(
      parent: _bioEntranceController,
      curve: Curves.easeOutCubic,
    );
    _bioSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bioEntranceController,
      curve: Curves.easeOutCubic,
    ));

    _buttonsEntranceController = AnimationController(
      vsync: this,
      duration: AnimationDurations.buttonsEntrance,
    );
    _buttonsFade = CurvedAnimation(
      parent: _buttonsEntranceController,
      curve: Curves.easeOutCubic,
    );
    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonsEntranceController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bioEntranceController.forward();
      _buttonsEntranceController.forward();
      _startTyping();
    });
  }

  void _startTyping() {
    final content = ref.read(heroSectionContentProvider);
    final full = content.bioText;

    _typingTimer?.cancel();
    _typedLength = 0;
    _typingTimer = Timer.periodic(AnimationDurations.typingTick, (timer) {
      if (!mounted) return;
      if (_typedLength >= full.length) {
        timer.cancel();
        return;
      }
      setState(() => _typedLength++);
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _gradientController.dispose();
    _bioEntranceController.dispose();
    _buttonsEntranceController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final launcher = ref.read(urlLauncherServiceProvider);
    final uri = Uri.parse(url);
    final ok = await launcher.openExternalUri(uri);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open: $url')),
      );
    }
  }

  Future<void> _openCv() async {
    final ok = await openBundledCvPdf(AssetPaths.cvPdf);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open CV PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(heroSectionContentProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedGradientBackdrop(controller: _gradientController),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final isMobile = w < Breakpoints.mobile;
                final isTablet =
                    w >= Breakpoints.mobile && w < Breakpoints.tablet;
                final horizontal = isMobile ? 20.0 : (isTablet ? 32.0 : 48.0);
                const maxContent = 1100.0;
                final gifMaxHeight =
                    isMobile ? w * 0.52 : (isTablet ? 340.0 : 420.0);
                final minH = constraints.maxHeight;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontal,
                    vertical: isMobile ? 24 : 40,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minH,
                      maxWidth: maxContent,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _gradientController,
                              builder: (context, _) {
                                final t = _gradientController.value;
                                final c = Color.lerp(
                                  AppColors.cyan,
                                  AppColors.orange,
                                  0.35 + 0.35 * math.sin(t * math.pi * 2),
                                )!;
                                return CustomPaint(
                                  painter: _HomeCornerBracketsPainter(
                                    color:
                                        c.withValues(alpha: 0.18 + 0.08 * t),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _HomeHeroIntro(
                                isMobile: isMobile,
                                pulse: _gradientController,
                              ),
                              SizedBox(height: isMobile ? 20 : 26),
                              AnimatedBuilder(
                                animation: _gradientController,
                                builder: (context, _) {
                                  final t = _gradientController.value;
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.cyan.withValues(
                                              alpha: 0.12 + 0.1 * t),
                                          blurRadius: 28,
                                          spreadRadius: -2,
                                        ),
                                        BoxShadow(
                                          color: AppColors.orange.withValues(
                                              alpha: 0.08),
                                          blurRadius: 40,
                                          spreadRadius: -6,
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.lerp(AppColors.cyan,
                                              AppColors.orange, t)!,
                                          Color.lerp(AppColors.orange,
                                              AppColors.cyan, t)!,
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                      child: HeroGifSection(
                                        maxHeight: gifMaxHeight,
                                        assetPath:
                                            content.heroGifAssetPath,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: isMobile ? 24 : 30),
                              FadeTransition(
                                opacity: _bioFade,
                                child: SlideTransition(
                                  position: _bioSlide,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 760,
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(22),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.14),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.surface.withValues(
                                                alpha: 0.55),
                                            AppColors.deep2.withValues(
                                                alpha: 0.42),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.deep1
                                                .withValues(alpha: 0.6),
                                            blurRadius: 24,
                                            offset: const Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          isMobile ? 18 : 26,
                                          isMobile ? 20 : 24,
                                          isMobile ? 18 : 26,
                                          isMobile ? 20 : 24,
                                        ),
                                        child: TypingBioDisplay(
                                          fullText: content.bioText,
                                          visibleLength: _typedLength,
                                          textAlign: TextAlign.center,
                                          baseStyle: GoogleFonts.montserrat(
                                            fontSize:
                                                isMobile ? 16 : 18,
                                            height: 1.58,
                                            color: Colors.white.withValues(
                                                alpha: 0.93),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isMobile ? 24 : 30),
                              FadeTransition(
                                opacity: _buttonsFade,
                                child: SlideTransition(
                                  position: _buttonsSlide,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: isMobile
                                          ? double.infinity
                                          : 760,
                                    ),
                                    child: HeroCtaRow(
                                      isMobile: isMobile,
                                      onGithub: () =>
                                          _openUrl(content.githubUrl),
                                      onLinkedIn: () =>
                                          _openUrl(content.linkedinUrl),
                                      onCv: _openCv,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeroIntro extends StatelessWidget {
  const _HomeHeroIntro({
    required this.isMobile,
    required this.pulse,
  });

  final bool isMobile;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final sub = GoogleFonts.montserrat(
      fontSize: isMobile ? 14 : 15,
      height: 1.45,
      fontWeight: FontWeight.w500,
      color: Colors.white.withValues(alpha: 0.72),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PORTFOLIO',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 10.5 : 11.5,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
            color: AppColors.cyan.withValues(alpha: 0.88),
          ),
        ),
        SizedBox(height: isMobile ? 8 : 10),
        AnimatedBuilder(
          animation: pulse,
          builder: (context, _) {
            final t = pulse.value;
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(-1 + t * 0.5, 0),
                  end: Alignment(1 - t * 0.35, 0),
                  colors: [
                    AppColors.cyan,
                    AppColors.orange,
                    AppColors.cyan.withValues(alpha: 0.9),
                  ],
                  stops: const [0.0, 0.52, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                'Production Level',
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  fontSize: isMobile ? 24 : 34,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: 0.4,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        SizedBox(height: isMobile ? 8 : 10),
        Text(
          'Senior mobile dev · clean architecture · UX that survives the field',
          textAlign: TextAlign.center,
          style: sub,
        ),
        SizedBox(height: isMobile ? 14 : 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: isMobile ? 8 : 12,
          runSpacing: 10,
          children: const [
            _HomeTagChip(label: 'Flutter & Android & IOS', hue: 0),
            _HomeTagChip(label: 'Web & mobile', hue: 1),
            _HomeTagChip(label: '8+ yrs in IT', hue: 2),
            _HomeTagChip(label: 'Clean Architecture · State Management', hue: 0),
          ],
        ),
      ],
    );
  }
}

class _HomeTagChip extends StatelessWidget {
  const _HomeTagChip({required this.label, required this.hue});

  final String label;
  final int hue;

  @override
  Widget build(BuildContext context) {
    final accent = hue.isEven ? AppColors.cyan : AppColors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: accent.withValues(alpha: 0.35),
        ),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.14),
            AppColors.deep1.withValues(alpha: 0.45),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

/// Light “viewfinder” corners — keeps the hero centered while differing from inner pages.
class _HomeCornerBracketsPainter extends CustomPainter {
  _HomeCornerBracketsPainter({required this.color});

  final Color color;

  static const _len = 32.0;
  static const _inset = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    void corner(double x0, double y0, double dx1, double dy1, double dx2,
        double dy2) {
      final path = Path()
        ..moveTo(x0 + dx1 * _len, y0 + dy1 * _len)
        ..lineTo(x0, y0)
        ..lineTo(x0 + dx2 * _len, y0 + dy2 * _len);
      canvas.drawPath(path, p);
    }

    corner(_inset, _inset, 1, 0, 0, 1);
    corner(size.width - _inset, _inset, -1, 0, 0, 1);
    corner(_inset, size.height - _inset, 1, 0, 0, -1);
    corner(size.width - _inset, size.height - _inset, -1, 0, 0, -1);
  }

  @override
  bool shouldRepaint(covariant _HomeCornerBracketsPainter oldDelegate) =>
      oldDelegate.color != color;
}

