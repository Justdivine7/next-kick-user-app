import 'package:flutter/material.dart';

class AppSettingsButton extends StatelessWidget {
  final void Function()? onButtonPressed;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  const AppSettingsButton({
    super.key,
    this.onButtonPressed,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Text(
          textAlign: TextAlign.center,
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
