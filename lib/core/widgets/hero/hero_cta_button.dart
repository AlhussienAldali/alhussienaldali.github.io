import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/animation_durations.dart';

class HeroCtaButton extends StatefulWidget {
  const HeroCtaButton({
    super.key,
    required this.label,
    required this.icon,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onPressed;

  @override
  State<HeroCtaButton> createState() => _HeroCtaButtonState();
}

class _HeroCtaButtonState extends State<HeroCtaButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scale = _hover ? 1.03 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: AnimationDurations.ctaHover,
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scaleByDouble(scale, scale, 1.0, 1.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(14),
            splashColor: widget.accent.withValues(alpha: 0.2),
            hoverColor: widget.accent.withValues(alpha: 0.12),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _hover
                      ? widget.accent
                      : widget.accent.withValues(alpha: 0.55),
                  width: _hover ? 2 : 1.5,
                ),
                gradient: LinearGradient(
                  colors: [
                    widget.accent.withValues(alpha: _hover ? 0.22 : 0.12),
                    widget.accent.withValues(alpha: _hover ? 0.08 : 0.04),
                  ],
                ),
                boxShadow: _hover
                    ? [
                        BoxShadow(
                          color: widget.accent.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: widget.accent, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      widget.label,
                      style: GoogleFonts.orbitron(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

