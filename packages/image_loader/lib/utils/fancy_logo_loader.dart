import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Fancy loader was created from aurora logo to mimic the one from their website
class FancyLogoLoader extends StatefulWidget {
  const FancyLogoLoader({
    super.key,
    required this.color,

    this.size = 100,
    this.duration = const Duration(milliseconds: 2500),
  });

  final Color color;

  final double size;
  final Duration duration;

  @override
  State<FancyLogoLoader> createState() => _FancyLogoLoaderState();
}

class _FancyLogoLoaderState extends State<FancyLogoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _baseScales = [0.5, 0.75, 1.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _grow(double t) => Curves.easeInOut.transform((t / 0.7).clamp(0, 1));

  double _converge(double t) =>
      Curves.easeInOut.transform(((t - 0.7) / 0.2).clamp(0, 1));

  double _scaleFor(int i, double t) =>
      lerpDouble(_baseScales[i], 1.0, _converge(t))! * _grow(t);

  double _spinProgress(double t) {
    // Spin fully during grow phase, slow down during converge
    final converge = _converge(t);
    return Curves.easeOut.transform(1 - converge);
  }

  double _rotateX(int i, double t) {
    final dirs = [1.0, -1.0, 0.6];
    return dirs[i] * 2 * pi * t * _spinProgress(t);
  }

  double _rotateY(int i, double t) {
    final dirs = [-0.6, 1.0, -1.0];
    return dirs[i] * 2 * pi * t * _spinProgress(t);
  }

  double _rotateZ(int i, double t) {
    final dirs = [1.0, -1.0, 1.0];
    return dirs[i] * 2 * pi * t;
  }

  double _opacityFor(int i, double t) => i == 2 ? 1 : 1 - _converge(t);

  @override
  Widget build(BuildContext context) {
    final baseSize = widget.size;

    return SizedBox(
      width: baseSize,
      height: baseSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          final t = _controller.value;

          return Stack(
            alignment: Alignment.center,
            children: List.generate(3, (i) {
              return Opacity(
                opacity: _opacityFor(i, t),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015) // perspective
                    ..rotateX(_rotateX(i, t))
                    ..rotateY(_rotateY(i, t))
                    ..rotateZ(_rotateZ(i, t))
                    // ignore: deprecated_member_use
                    ..scale(_scaleFor(i, t)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow layer
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            widget.color,
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/logo-o.png',
                            package: 'image_loader',
                            width: widget.size,
                          ),
                        ),
                      ),

                      // Original logo
                      Image.asset(
                        'assets/logo-o.png',
                        package: 'image_loader',
                        width: widget.size,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
