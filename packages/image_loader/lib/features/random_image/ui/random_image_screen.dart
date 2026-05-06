import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_loader/constants.dart';
import 'package:image_loader/features/random_image/notifier/random_image_change_notifier.dart';
import 'package:image_loader/features/random_image/repo/image_repository.dart';
import 'package:image_loader/utils/app_visual_theme.dart';
import 'package:image_loader/utils/fancy_logo_loader.dart';
import 'package:image_loader/utils/outline_button.dart';
import 'package:image_loader/utils/remote_image.dart';
import 'package:provider/provider.dart';

///Main screen for Displaying all UI components
class RandomImageScreen extends StatelessWidget {
  const RandomImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RandomImageChangeNotifier(ImageRepository())..loadImage(),
      child: const _RandomImageView(),
    );
  }
}

class _RandomImageView extends StatelessWidget {
  const _RandomImageView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RandomImageChangeNotifier>();
    final visuals = Theme.of(context).extension<AppVisualTheme>()!;
    final Color backgroundColor = controller.isLoading
        ? visuals.backGroundColor
        : controller.backgroundColor;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //  Dynamic background color
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            color: backgroundColor,
          ),

          //   blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: const SizedBox.expand(),
          ),

          //   depth overlay
          Container(
            color: Colors.black.withAlpha(
              (visuals.overlayOpacity * 255).round(),
            ),
          ),
          // Main content (logo + image)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.isLoading)
                  SizedBox(
                    height: 240,
                    child: Center(
                      child: FancyLogoLoader(color: visuals.glowColor),
                    ),
                  )
                else if (controller.errorMessage != null)
                  Text(
                    controller.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                else if (controller.imageUrl != null)
                  RemoteImage(imageUrl: controller.imageUrl!, size: 240),
                const SizedBox(height: 24),
                !controller.isLoading
                    ? OutlineButton(
                        text: buttonText,

                        onPressed: controller.isLoading
                            ? null
                            : controller.loadImage,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
