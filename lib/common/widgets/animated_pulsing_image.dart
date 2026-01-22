import 'package:flutter/material.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';

class AnimatedPulsingImage extends StatefulWidget {
  final String? imagePath;
  final double size;
  final Duration duration;
  final bool isAnimating;

  const AnimatedPulsingImage({
    super.key,
    this.imagePath,
    this.size = 120,
    this.duration = const Duration(milliseconds: 1500),
    this.isAnimating = true,
  });

  @override
  State<AnimatedPulsingImage> createState() => _AnimatedPulsingImageState();
}

class _AnimatedPulsingImageState extends State<AnimatedPulsingImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPulsingImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Image.asset(
              widget.imagePath ?? AppImageStrings.manLogo,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
