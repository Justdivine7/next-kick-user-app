  import 'package:flutter/material.dart';
import 'package:next_kick/common/widgets/app_toast/toast_container.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';

class AnimatedToast extends StatefulWidget {
  final String message;
  final ToastStyle style;

  final ValueNotifier<AnimationController?> controllerNotifier;
  const AnimatedToast({
    super.key,
    required this.message,
    required this.controllerNotifier,
    required this.style,
  });

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    widget.controllerNotifier.value = _controller;

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: ToastContainer(message: widget.message, style: widget.style),
        ),
      ),
    );
  }
}
