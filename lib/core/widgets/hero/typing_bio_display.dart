import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'blinking_caret.dart';

/// Typing-style paragraph with a blinking caret (character count from parent state).
class TypingBioDisplay extends StatelessWidget {
  const TypingBioDisplay({
    super.key,
    required this.fullText,
    required this.visibleLength,
    required this.textAlign,
    required this.baseStyle,
  });

  final String fullText;
  final int visibleLength;
  final TextAlign textAlign;
  final TextStyle baseStyle;

  @override
  Widget build(BuildContext context) {
    final visible = visibleLength <= fullText.length
        ? fullText.substring(0, visibleLength)
        : fullText;

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: visible),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: BlinkingCaret(
              color: AppColors.cyan,
              fontSize: baseStyle.fontSize ?? 16,
            ),
          ),
        ],
      ),
    );
  }
}

