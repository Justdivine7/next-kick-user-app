import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Color? fillColor;
  final Color? textColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? hintColor;
  final TextEditingController textController;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Color? errorColor;
  final BorderSide? errorBorder;
  const AppTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixIconColor,
    this.prefixIconColor,
    required this.textController,
    required this.obscure,
    this.validator,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.keyboardType,
    this.errorColor,
    this.errorBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textController,
      style: TextStyle(color: textColor ?? AppColors.darkBackButton),
      obscureText: obscure,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: errorColor ?? AppColors.whiteColor),
        contentPadding: EdgeInsets.all(10),
        fillColor: fillColor ?? AppColors.whiteColor,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor ?? AppColors.borderColor),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconColor: suffixIconColor,
        prefixIconColor: prefixIconColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: enabledBorderColor ?? AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.lightBackgroundGradient,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              errorBorder ??
              BorderSide(color: AppColors.solidOrange), 
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.appPrimaryColor),
        ),
      ),
    );
  }
}
