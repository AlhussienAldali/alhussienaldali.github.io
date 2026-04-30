import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/animation_durations.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
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
        _buttonsEntranceController.forward();
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HeroGifSection(
                            maxHeight: gifMaxHeight,
                            assetPath: content.heroGifAssetPath,
                          ),
                          SizedBox(height: isMobile ? 28 : 36),
                          FadeTransition(
                            opacity: _bioFade,
                            child: SlideTransition(
                              position: _bioSlide,
                              child: TypingBioDisplay(
                                fullText: content.bioText,
                                visibleLength: _typedLength,
                                textAlign: TextAlign.center,
                                baseStyle: GoogleFonts.montserrat(
                                  fontSize: isMobile ? 16 : 18,
                                  height: 1.55,
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 28 : 36),
                          FadeTransition(
                            opacity: _buttonsFade,
                            child: SlideTransition(
                              position: _buttonsSlide,
                              child: HeroCtaRow(
                                isMobile: isMobile,
                                onGithub: () => _openUrl(content.githubUrl),
                                onDemo: () => _openUrl(content.liveDemoUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
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

