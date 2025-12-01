import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';

class AppDropDownWidget extends StatelessWidget {
  final String label;
  final List<String> dropDownList;
  final String validatorName;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  const AppDropDownWidget({
    super.key,
    required this.label,
    required this.dropDownList,
    required this.validatorName,
    this.controller,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String? selectedValue =
        initialValue ??
        (controller?.text.isNotEmpty == true ? controller!.text : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(height: getScreenHeight(context, 0.008)),

        SizedBox(
          // width: getScreenWidth(context, 0.6),
          child: DropdownButtonFormField<String>(
            initialValue: selectedValue,
            validator:
                (value) =>
                    validateField(value: value, fieldName: validatorName),

            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            dropdownColor: AppColors.whiteColor,

            hint: Text(label, style: TextStyle(color: AppColors.subTextcolor)),
            items:
                dropDownList
                    .map(
                      (position) => DropdownMenuItem<String>(
                        value: position,
                        child: Text(
                          position,
                          style: TextStyle(color: AppColors.darkBackButton),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (selectedItem) {
              if (controller != null && selectedItem != null) {
                controller!.text = selectedItem;
              }
              onChanged?.call(selectedItem);
              debugPrint('Selected $validatorName: $selectedItem');
            },
          ),
        ),
      ],
    );
  }
}
