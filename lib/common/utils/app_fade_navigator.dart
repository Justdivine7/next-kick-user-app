import 'package:flutter/material.dart';

PageRouteBuilder createFadeTransition(
  Widget targetScreen, {
  Duration duration = const Duration(milliseconds: 800),
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

PageRouteBuilder createSlideTransition(
  Widget targetScreen, {
  Duration duration = const Duration(milliseconds: 300),
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final Animation<Offset> offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
