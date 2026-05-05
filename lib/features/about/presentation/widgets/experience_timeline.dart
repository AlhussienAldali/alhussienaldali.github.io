import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/experience_item.dart';

/// Vertical timeline with a glowing spine — reads as a career arc, not a flat list.
class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({
    super.key,
    required this.items,
    required this.isMobile,
  });

  final List<ExperienceItem> items;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 18),
            child: _TimelineEntry(
              item: items[i],
              isMobile: isMobile,
              isLast: i == items.length - 1,
              accent: i.isEven ? AppColors.cyan : AppColors.orange,
            ),
          ),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.item,
    required this.isMobile,
    required this.isLast,
    required this.accent,
  });

  final ExperienceItem item;
  final bool isMobile;
  final bool isLast;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: isMobile ? 28 : 34,
            child: Column(
              children: [
                Container(
                  width: isMobile ? 14 : 16,
                  height: isMobile ? 14 : 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withValues(alpha: 0.95),
                        accent.withValues(alpha: 0.12),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.45),
                        blurRadius: 12,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                accent.withValues(alpha: 0.75),
                                AppColors.deep3.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                          child: const SizedBox(width: 3),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(20),
                  bottomLeft: const Radius.circular(20),
                  topLeft: Radius.circular(isMobile ? 6 : 8),
                  bottomRight: Radius.circular(isMobile ? 6 : 8),
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface.withValues(alpha: 0.72),
                    AppColors.deep2.withValues(alpha: 0.35),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 14 : 18,
                  isMobile ? 14 : 18,
                  isMobile ? 14 : 18,
                  isMobile ? 14 : 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.role,
                            style: GoogleFonts.orbitron(
                              fontSize: isMobile ? 15 : 17,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: accent.withValues(alpha: 0.12),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            item.period,
                            style: GoogleFonts.montserrat(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.88),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.company} · ${item.location}',
                      style: GoogleFonts.montserrat(
                        fontSize: 13.2,
                        fontWeight: FontWeight.w600,
                        color: accent.withValues(alpha: 0.92),
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final h in item.highlights) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11,
                              color: accent.withValues(alpha: 0.75),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              h,
                              style: GoogleFonts.montserrat(
                                fontSize: 13.75,
                                height: 1.58,
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
