import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/label_and_text_field.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';

class PasswordFieldWidget extends StatefulWidget {
  final ValueNotifier<bool> showPassword;
  final TextEditingController passwordController;
  final String fieldName;
  final String? hintText;

  const PasswordFieldWidget({
    super.key,
    required this.showPassword,
    required this.passwordController,
    required this.fieldName,
    this.hintText
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.showPassword,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.topLeft,
          child: LabelAndTextField(
            label: widget.fieldName,
            textController: widget.passwordController,
            hintText: widget.hintText ??widget.fieldName,
            obscure: value,
            suffixIcon: GestureDetector(
              onTap: () {
                widget.showPassword.value = !widget.showPassword.value;
              },
              child: Icon(
                value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.borderColor,
              ),
            ),
            validator:
                (value) =>
                    validatePassword(value: value, fieldName: widget.fieldName),
          ),
        );
      },
    );
  }
}
