import 'package:flutter/material.dart';
import 'package:next_kick/common/widgets/animated_pulsing_image.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isVisible;
  final String? imagePath;

  const AppLoadingOverlay({super.key, this.isVisible = true, this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Material(
      color: Colors.black54,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: AnimatedPulsingImage(
            imagePath: imagePath ?? AppImageStrings.manLogo,
          ),
        ),
      ),
    );
  }
}
