import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';

/// Neon memory match — colorful board, subtle motion, centered grid (no dead bottom gap).
class NeonMemoryLabPage extends StatefulWidget {
  const NeonMemoryLabPage({super.key});

  @override
  State<NeonMemoryLabPage> createState() => _NeonMemoryLabPageState();
}

class _NeonMemoryLabPageState extends State<NeonMemoryLabPage>
    with TickerProviderStateMixin {
  static const _pairCount = 8;

  late final AnimationController _ambient;

  final _rand = math.Random();

  late List<int> _pairIds;
  final List<bool> _matched = List.filled(16, false);
  final List<bool> _faceUp = List.filled(16, false);

  int? _firstIndex;
  int _moves = 0;
  bool _lockInput = false;

  static const _glyphs = [
    Icons.bolt_rounded,
    Icons.memory_rounded,
    Icons.hub_rounded,
    Icons.developer_mode_rounded,
    Icons.auto_fix_high_rounded,
    Icons.layers_rounded,
    Icons.polyline_rounded,
    Icons.extension_rounded,
  ];

  /// Accent per pair id (face-down backs stay vivid but not tilted — vertical blends only).
  static const _pairColors = <Color>[
    Color(0xFF00E5FF),
    Color(0xFFFF4D40),
    Color(0xFFB388FF),
    Color(0xFF69F0AE),
    Color(0xFFFFEA00),
    Color(0xFFFF4081),
    Color(0xFF82B1FF),
    Color(0xFFFFB74D),
  ];

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _shuffleDeck();
  }

  void _shuffleDeck() {
    final ids = <int>[for (var i = 0; i < _pairCount; i++) ...[i, i]];
    ids.shuffle(_rand);
    setState(() {
      _pairIds = ids;
      for (var i = 0; i < 16; i++) {
        _matched[i] = false;
        _faceUp[i] = false;
      }
      _firstIndex = null;
      _moves = 0;
      _lockInput = false;
    });
  }

  bool get _won => _matched.every((m) => m);

  Future<void> _onTileTap(int index) async {
    if (_lockInput || _matched[index] || _faceUp[index]) return;
    setState(() {
      _faceUp[index] = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    final a = _firstIndex!;
    final b = index;
    _firstIndex = null;
    _moves++;

    if (_pairIds[a] == _pairIds[b]) {
      setState(() {
        _matched[a] = true;
        _matched[b] = true;
      });
      return;
    }

    _lockInput = true;
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      _faceUp[a] = false;
      _faceUp[b] = false;
      _lockInput = false;
    });
  }

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < Breakpoints.mobile;
    final pad = isMobile ? 18.0 : 36.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _ambient,
              builder: (context, _) {
                return CustomPaint(
                  painter: _NeonWashPainter(t: _ambient.value),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(pad, 18, pad, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  final t = _ambient.value;
                  return LinearGradient(
                    begin: Alignment(-1 + t * 0.4, 0),
                    end: Alignment(1 - t * 0.3, 0),
                    colors: [
                      AppColors.cyan,
                      AppColors.orange,
                      AppColors.cyan.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  'Neon Memory',
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 26 : 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Flip two tiles at your pace — find all $_pairCount pairs. '
                'No countdown; take your time.',
                style: GoogleFonts.montserrat(
                  fontSize: isMobile ? 14.5 : 16,
                  height: 1.55,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _MiniStat(label: 'Moves', value: '$_moves'),
                  const SizedBox(width: 12),
                  _MiniStat(
                    label: 'Pairs',
                    value:
                        '${_matched.where((m) => m).length ~/ 2}/$_pairCount',
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _shuffleDeck,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: AppColors.cyan.withValues(alpha: 0.95),
                    ),
                    label: Text(
                      'Shuffle deck',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    const gap = 10.0;
                    const panelPad = 14.0;
                    final maxSide = math.min(
                      c.maxWidth - 2 * panelPad,
                      c.maxHeight - 2 * panelPad,
                    );
                    final cell =
                        ((maxSide - 3 * gap) / 4).clamp(48.0, 102.0);
                    final board = 4 * cell + 3 * gap;

                    return Center(
                      child: AnimatedBuilder(
                        animation: _ambient,
                        builder: (context, _) {
                          final t = _ambient.value;
                          final wash = Color.lerp(
                            AppColors.deep2,
                            AppColors.deep3,
                            t,
                          )!;
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                width: 1.5,
                                color: Color.lerp(
                                  AppColors.cyan,
                                  AppColors.orange,
                                  t,
                                )!
                                    .withValues(alpha: 0.45 + 0.2 * t),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyan
                                      .withValues(alpha: 0.12 + 0.08 * t),
                                  blurRadius: 24,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.orange
                                      .withValues(alpha: 0.08),
                                  blurRadius: 32,
                                  spreadRadius: -4,
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.deep1.withValues(alpha: 0.88),
                                  wash.withValues(alpha: 0.92),
                                  Color.lerp(
                                    AppColors.surface,
                                    AppColors.deep2,
                                    t,
                                  )!.withValues(alpha: 0.75),
                                ],
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(panelPad),
                              child: SizedBox(
                                width: board,
                                height: board,
                                child: GridView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: gap,
                                    mainAxisSpacing: gap,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: 16,
                                  itemBuilder: (context, i) {
                                    final pair = _pairIds[i];
                                    final icon = _glyphs[pair];
                                    final show = _matched[i] || _faceUp[i];
                                    return _Tile(
                                      tileIndex: i,
                                      pairColor: _pairColors[
                                          pair % _pairColors.length],
                                      show: show,
                                      matched: _matched[i],
                                      icon: icon,
                                      pulseT: t,
                                      onTap: () => _onTileTap(i),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              if (_won) ...[
                const SizedBox(height: 8),
                Text(
                  'Signal aligned — grid restored.',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.cyan.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NeonWashPainter extends CustomPainter {
  _NeonWashPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * (0.35 + 0.3 * math.sin(t * math.pi * 2));
    final cy = size.height * (0.25 + 0.15 * math.cos(t * math.pi * 2 * 0.7));

    void blob(Offset c, double r, Color color) {
      final p = Paint()
        ..color = color.withValues(alpha: 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48);
      canvas.drawCircle(c, r, p);
    }

    blob(Offset(cx, cy), size.shortestSide * 0.38,
        Color.lerp(AppColors.cyan, AppColors.deep2, 0.5)!);
    blob(Offset(size.width * 0.75, size.height * 0.55), size.shortestSide * 0.32,
        Color.lerp(AppColors.orange, AppColors.deep2, 0.5)!);
    blob(Offset(size.width * 0.2 + 40 * t, size.height * 0.7),
        size.shortestSide * 0.26, AppColors.cyan);

    final edge = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.6, -0.4),
        radius: 1.15,
        colors: [
          AppColors.cyan.withValues(alpha: 0.06),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, edge);
  }

  @override
  bool shouldRepaint(covariant _NeonWashPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.25),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cyan.withValues(alpha: 0.12),
            AppColors.deep2.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label · ',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.orange.withValues(alpha: 0.98),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.tileIndex,
    required this.pairColor,
    required this.show,
    required this.matched,
    required this.icon,
    required this.pulseT,
    required this.onTap,
  });

  /// Grid slot — used for **cosmetic** face-down tint only (not derived from pair).
  final int tileIndex;
  final Color pairColor;
  final bool show;
  final bool matched;
  final IconData icon;
  final double pulseT;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glow = matched ? 0.35 + 0.15 * math.sin(pulseT * math.pi * 2) : 0.0;

    // Face-down backs must not encode pair id — tint from slot index only.
    final backPhase = (tileIndex % 8) / 7.0;
    final backTop = Color.lerp(
      AppColors.deep2,
      AppColors.deep3,
      backPhase,
    )!;
    final backBottom = Color.lerp(
      AppColors.surface,
      AppColors.deep1,
      0.35 + 0.2 * ((tileIndex * 3) % 5) / 4.0,
    )!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: matched
                  ? Color.lerp(AppColors.cyan, pairColor, 0.45)!.withValues(
                      alpha: 0.75 + 0.15 * glow,
                    )
                  : show
                      ? pairColor.withValues(alpha: 0.55)
                      : Colors.white.withValues(alpha: 0.1 + 0.02 * (tileIndex % 4)),
              width: matched ? 2.2 : 1.2,
            ),
            gradient: show
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      pairColor.withValues(alpha: matched ? 0.42 : 0.32),
                      AppColors.deep3.withValues(alpha: 0.62),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backTop.withValues(alpha: 0.95),
                      backBottom.withValues(alpha: 0.92),
                    ],
                  ),
            boxShadow: matched
                ? [
                    BoxShadow(
                      color: pairColor.withValues(alpha: 0.35 + glow * 0.3),
                      blurRadius: 16 + 8 * glow,
                      spreadRadius: -1,
                    ),
                  ]
                : show
                    ? [
                        BoxShadow(
                          color: pairColor.withValues(alpha: 0.15),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, anim) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOutBack,
                  ),
                  child: FadeTransition(opacity: anim, child: child),
                );
              },
              child: show
                  ? Icon(
                      icon,
                      key: ValueKey(icon),
                      size: 34,
                      color: Colors.white.withValues(alpha: 0.96),
                    )
                  : Icon(
                      Icons.blur_on_rounded,
                      key: ValueKey<String>('back$tileIndex'),
                      size: 28,
                      color: AppColors.cyan.withValues(alpha: 0.32),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
