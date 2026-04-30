import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/animation_durations.dart';

class BlinkingCaret extends StatefulWidget {
  const BlinkingCaret({
    super.key,
    required this.color,
    required this.fontSize,
  });

  final Color color;
  final double fontSize;

  @override
  State<BlinkingCaret> createState() => _BlinkingCaretState();
}

class _BlinkingCaretState extends State<BlinkingCaret>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AnimationDurations.caretBlink,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        '|',
        style: GoogleFonts.robotoMono(
          color: widget.color,
          fontSize: widget.fontSize * 1.1,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

