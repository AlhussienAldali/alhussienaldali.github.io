import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';

/// Slow-paced **neon memory** — match 8 pairs of glyphs. No reflex timer pressure.
class NeonMemoryLabPage extends StatefulWidget {
  const NeonMemoryLabPage({super.key});

  @override
  State<NeonMemoryLabPage> createState() => _NeonMemoryLabPageState();
}

class _NeonMemoryLabPageState extends State<NeonMemoryLabPage>
    with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 22, pad, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Neon Memory',
            style: GoogleFonts.orbitron(
              fontSize: isMobile ? 26 : 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Flip two tiles at your pace — find all $_pairCount pairs. '
            'No countdown; take your time.',
            style: GoogleFonts.montserrat(
              fontSize: isMobile ? 14.5 : 16,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 14),
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
                icon: Icon(Icons.refresh_rounded,
                    color: AppColors.cyan.withValues(alpha: 0.95)),
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
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _ambient,
              builder: (context, _) {
                final t = _ambient.value;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Color.lerp(AppColors.cyan, AppColors.orange, t)!
                          .withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment(-0.9 + t * 0.3, -1),
                      end: Alignment(0.9 - t * 0.2, 1),
                      colors: [
                        AppColors.deep1.withValues(alpha: 0.92),
                        AppColors.surface.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: LayoutBuilder(
                      builder: (context, c) {
                        const gap = 10.0;
                        final cellW = (c.maxWidth - gap * 3) / 4;
                        final maxH = c.maxHeight;
                        var cellH = (maxH - gap * 3) / 4;
                        if (cellH > cellW) cellH = cellW;
                        cellH = cellH.clamp(52.0, 120.0);
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: gap,
                            mainAxisSpacing: gap,
                            mainAxisExtent: cellH,
                          ),
                          itemCount: 16,
                          itemBuilder: (context, i) {
                            final pair = _pairIds[i];
                            final icon = _glyphs[pair];
                            final show = _matched[i] || _faceUp[i];
                            return _Tile(
                              show: show,
                              matched: _matched[i],
                              icon: icon,
                              onTap: () => _onTileTap(i),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (_won) ...[
            const SizedBox(height: 12),
            Text(
              'Signal aligned — grid restored.',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.cyan.withValues(alpha: 0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
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
          color: Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$label · ',
            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white54),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.orange.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.show,
    required this.matched,
    required this.icon,
    required this.onTap,
  });

  final bool show;
  final bool matched;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                  ? AppColors.cyan.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.14),
              width: matched ? 2 : 1,
            ),
            gradient: show
                ? LinearGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: matched ? 0.28 : 0.18),
                      AppColors.deep3.withValues(alpha: 0.55),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      AppColors.deep2.withValues(alpha: 0.35),
                    ],
                  ),
            boxShadow: show && matched
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.22),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: show
                  ? Icon(
                      icon,
                      key: ValueKey(icon),
                      size: 34,
                      color: Colors.white.withValues(alpha: 0.95),
                    )
                  : Icon(
                      Icons.blur_on_rounded,
                      key: const ValueKey('back'),
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
