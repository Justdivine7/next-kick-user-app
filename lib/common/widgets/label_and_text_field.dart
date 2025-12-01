import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_text_form_field.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';

class LabelAndTextField extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  final String hintText;
  final bool obscure;
  final Color? labelColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Color? errorColor;
  final BorderSide? errorBorder;
  const LabelAndTextField({
    super.key,
    required this.label,
    required this.textController,
    required this.hintText,
    required this.obscure,
    this.labelColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.errorColor,
    this.errorBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            color: labelColor ?? AppColors.whiteColor,
          ),
        ),
        SizedBox(height: getScreenHeight(context, 0.008)),

        AppTextFormField(
          validator: validator,
          hintText: hintText,
          textController: textController,
          obscure: obscure,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          keyboardType: keyboardType,
          errorColor: errorColor,
          errorBorder: errorBorder,
        ),
      ],
    );
  }
}
