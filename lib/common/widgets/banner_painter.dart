import 'package:flutter/material.dart';

/// Badge with a backslash-style slanted left edge (`\`) and an inward (concave) right curve.
/// Pass any child (Text, Row, etc).
class LeftBackslashRightConcaveBadge extends StatelessWidget {
  final Widget child;
  final double height;
  final double leftSlant; // how far the bottom-left is inset to the right (creates the "\" slope)
  final double rightInset; // how far from the right the curve's endpoints sit (start/end of the curve)
  final double rightControlOffset; // how far left from the right edge the quadratic control point sits (bigger -> deeper concave)
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double? width;

  const LeftBackslashRightConcaveBadge({
    super.key,
    required this.child,
    this.height = 56,
    this.leftSlant = 30,
    this.rightInset = 36,
    this.rightControlOffset = 18,
    this.color = const Color(0xFF0E5C82),
    this.gradient,
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.width,
  })  : assert(leftSlant >= 0),
        assert(rightInset >= 0),
        assert(rightControlOffset >= 0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _ConcavePainter(
          leftSlant: leftSlant,
          rightInset: rightInset,
          rightControlOffset: rightControlOffset,
          color: color,
          gradient: gradient,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ),
        child: ClipPath(
          clipper: _ConcaveClipper(
            leftSlant: leftSlant,
            rightInset: rightInset,
            rightControlOffset: rightControlOffset,
          ),
          child: Padding(
            padding: padding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConcavePainter extends CustomPainter {
  final double leftSlant;
  final double rightInset;
  final double rightControlOffset;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;

  _ConcavePainter({
    required this.leftSlant,
    required this.rightInset,
    required this.rightControlOffset,
    required this.color,
    required this.gradient,
    required this.borderColor,
    required this.borderWidth,
  });

  Path _makePath(Rect r) {
    final p = Path();

    // Top-left sits at the left edge (x = r.left)
    p.moveTo(r.left, r.top);

    // Top edge to the point where the right curve begins
    p.lineTo(r.right - rightInset, r.top);

    // Quadratic curve inward (concave) from top-right area to bottom-right area
    // Control point sits inside the rect (r.right - rightControlOffset) to make the curve go inwards.
    p.quadraticBezierTo(
      r.right - rightControlOffset, // control x inside the rect
      r.center.dy, // control y centered vertically
      r.right - rightInset, // end point on bottom near right
      r.bottom,
    );

    // Bottom edge back toward the left; bottom-left is inset to the right by leftSlant
    p.lineTo(r.left + leftSlant, r.bottom);

    // Close back to top-left (r.left, r.top)
    p.close();
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = _makePath(rect);

    final fillPaint = Paint()..style = PaintingStyle.fill..isAntiAlias = true;
    if (gradient != null) {
      fillPaint.shader = gradient!.createShader(rect);
    } else {
      fillPaint.color = color ?? Colors.blue;
    }

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round
      ..color = borderColor;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _ConcavePainter old) {
    return old.leftSlant != leftSlant ||
        old.rightInset != rightInset ||
        old.rightControlOffset != rightControlOffset ||
        old.color != color ||
        old.gradient != gradient ||
        old.borderColor != borderColor ||
        old.borderWidth != borderWidth;
  }
}

class _ConcaveClipper extends CustomClipper<Path> {
  final double leftSlant;
  final double rightInset;
  final double rightControlOffset;

  _ConcaveClipper({
    required this.leftSlant,
    required this.rightInset,
    required this.rightControlOffset,
  });

  Path _makePath(Rect r) {
    final p = Path();
    p.moveTo(r.left, r.top);
    p.lineTo(r.right - rightInset, r.top);
    p.quadraticBezierTo(
      r.right - rightControlOffset,
      r.center.dy,
      r.right - rightInset,
      r.bottom,
    );
    p.lineTo(r.left + leftSlant, r.bottom);
    p.close();
    return p;
  }

  @override
  Path getClip(Size size) => _makePath(Offset.zero & size);

  @override
  bool shouldReclip(covariant _ConcaveClipper old) {
    return old.leftSlant != leftSlant ||
        old.rightInset != rightInset ||
        old.rightControlOffset != rightControlOffset;
  }
}
