import 'package:flutter/material.dart';
import 'package:next_kick/common/widgets/app_toast/animated_toast.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';

class AppToast {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static AnimationController? _currentToastController;

  static ValueNotifier<AnimationController?> _controllerNotifier =
      ValueNotifier(null);

  static void show(
    BuildContext context, {
    required String message,
    required ToastStyle style,

    Duration duration = const Duration(seconds: 4),
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    if (_isVisible) {
      _overlayEntry?.remove();
      _isVisible = false;
      _currentToastController = null;
      _controllerNotifier.value = null;
    }
    _controllerNotifier = ValueNotifier(null);
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 65,
            left: 40,
            right: 40,
            child: AnimatedToast(
              message: message,
              style: style,
              controllerNotifier: _controllerNotifier,
            ),
          ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;

    _controllerNotifier.addListener(() {
      if (_controllerNotifier.value != null) {
        _currentToastController = _controllerNotifier.value;
        Future.delayed(duration, () {
          hide();
        });
      }
    });
  }

  static void hide() {
    if (_isVisible && _currentToastController != null) {
      _currentToastController?.reverse().then((_) {
        _overlayEntry?.remove();
        _isVisible = false;
        _overlayEntry = null;
        _controllerNotifier.value = null;
        _currentToastController = null;
      });
    } else if (_isVisible) {
      _overlayEntry?.remove();
      _isVisible = false;
      _overlayEntry = null;
      _controllerNotifier.value = null;
      _currentToastController = null;
    }
  }
}
