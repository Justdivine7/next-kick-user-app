import 'package:flutter/material.dart';

class TeamFCPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define colors
    final Color mainBlue = Color(0xFF2C6BB6); // A bit lighter blue than background
    final Color borderColor = Colors.white;
    final Color shadowColor = Colors.black.withOpacity(0.3); // For the subtle shadow

    // --- Main Shape Path ---
    Path mainPath = Path();
    mainPath.moveTo(0, 0); // Top-left
    mainPath.lineTo(size.width * 0.75, 0); // Top-right (slanted start)
    mainPath.lineTo(size.width, size.height); // Bottom-right (slanted end)
    mainPath.lineTo(0, size.height); // Bottom-left
    mainPath.close();

    // --- Draw Shadow ---
    canvas.drawPath(
      mainPath,
      Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0), // Adjust blur amount
    );

    // --- Draw Main Shape Fill ---
    canvas.drawPath(
      mainPath,
      Paint()..color = mainBlue,
    );

    // --- Draw Border ---
    Path borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(size.width * 0.75, 0);
    borderPath.lineTo(size.width, size.height);
    borderPath.lineTo(0, size.height);
    borderPath.close();

    canvas.drawPath(
      borderPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0, // Adjust border thickness
    );

    // --- Draw Overlapping Circle (Semi-circle effect) ---
    // The exact position and size will need fine-tuning based on your desired look.
    // This creates a circle that is partially off-canvas to give the semi-circle look.
    final double circleRadius = size.height * 0.6; // Adjust radius
    final Offset circleCenter = Offset(size.width * 0.95 + circleRadius, size.height / 2); // Adjust center X to move it off-canvas

    canvas.drawCircle(
      circleCenter,
      circleRadius,
      Paint()
        ..color = Colors.white,
    );

    // To create the inner white circle part with the outer ring effect,
    // you might need another circle or clip the canvas. For simplicity,
    // let's just draw an inner circle for now.
    canvas.drawCircle(
      circleCenter,
      circleRadius * 0.8, // Smaller inner circle
      Paint()
        ..color = mainBlue, // Or transparent with blend mode if you want to see through
    );

    // --- Lighter blue background (top-left) ---
    // This part is a bit trickier to get the exact gradient/fade.
    // For a simpler approach, you can draw a rectangular path or use a Shader.
    // Let's draw a simple light blue rectangular area on the left.
    // For a more advanced fade, consider using a LinearGradient.
    canvas.drawRect(
      Rect.fromLTWH(-size.width * 0.3, -size.height * 0.3, size.width * 0.4, size.height * 1.6), // Adjust position and size
      Paint()
        ..color = Color(0xFF6DA3D9).withOpacity(0.7), // Lighter blue with some opacity
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
