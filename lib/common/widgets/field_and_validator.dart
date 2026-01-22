import 'package:flutter/material.dart';
import 'package:next_kick/common/widgets/label_and_text_field.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';

class FieldAndValidator extends StatelessWidget {
  final String fieldName;
  final TextEditingController textController;
  final bool obscure;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool isEmail;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? textColor;

  const FieldAndValidator({
    super.key,
    required this.fieldName,
    required this.textController,
    required this.obscure,
    this.hintText,
    this.keyboardType,
    this.isEmail = false,
    this.readOnly = false,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return LabelAndTextField(
      readOnly: readOnly,
      onTap: onTap,
      textColor: textColor,
      label: fieldName,

      textController: textController,
      hintText: hintText ?? fieldName,
      keyboardType: keyboardType,

      obscure: obscure,
      validator: (value) {
        if (isEmail) {
          return validateEmail(value: value, fieldName: fieldName);
        } else {
          return validateField(value: value, fieldName: fieldName);
        }
      },
    );
  }
}
