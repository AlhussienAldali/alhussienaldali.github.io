import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cv_open/cv_open.dart';
import '../../../../core/widgets/hero/hero_cta_button.dart';
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
        final horizontal = isMobile ? 20.0 : (isTablet ? 32.0 : 48.0);
        final maxWidth = isMobile ? double.infinity : 900.0;

        final buttons = <Widget>[
          HeroCtaButton(
            label: 'Email',
            icon: Icons.email_rounded,
            accent: AppColors.cyan,
            onPressed: () => openUrl(links.email),
          ),
          HeroCtaButton(
            label: 'LinkedIn',
            icon: Icons.work_rounded,
            accent: AppColors.orange,
            onPressed: () => openUrl(links.linkedinUrl),
          ),
          HeroCtaButton(
            label: 'GitHub',
            icon: Icons.code_rounded,
            accent: AppColors.cyan,
            onPressed: () => openUrl(links.githubUrl),
          ),
          if (links.phoneTel != null)
            HeroCtaButton(
              label: 'Phone',
              icon: Icons.phone_rounded,
              accent: AppColors.orange,
              onPressed: () => openUrl(links.phoneTel!),
            ),
          HeroCtaButton(
            label: 'Download CV',
            icon: Icons.description_rounded,
            accent: AppColors.orange,
            onPressed: openCv,
          ),
        ];

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: GoogleFonts.orbitron(
                      fontSize: isMobile ? 26 : 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Romania · Bucharest · Remote-friendly.',
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile ? 15.5 : 17,
                      height: 1.6,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ResponsiveButtons(isMobile: isMobile, children: buttons),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ResponsiveButtons extends StatelessWidget {
  const _ResponsiveButtons({required this.isMobile, required this.children});

  final bool isMobile;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const SizedBox(height: 14),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final c in children) SizedBox(width: 280, child: c),
      ],
    );
  }
}
