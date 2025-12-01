import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/app_text_form_field.dart';
import 'package:next_kick/data/models/drill_model.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class DrillWidget extends StatefulWidget {
  final DrillModel drill;
  final void Function(String link) onSubmit;

  const DrillWidget({super.key, required this.drill, required this.onSubmit});

  @override
  State<DrillWidget> createState() => _DrillWidgetState();
}

class _DrillWidgetState extends State<DrillWidget> {
  final TextEditingController _drillLinkController = TextEditingController();

  /// Determines the drill's current status based on backend fields
  String get drillStatus {
    final d = widget.drill;

    if (d.isRejected == true) return "rejected";
    if (d.isCompleted && d.isApproved) return "completed";
    if (d.isCompleted && !d.isApproved) return "awaiting";
    if (!d.canAttempt) return "locked";
    return "active";
  }

  @override
  Widget build(BuildContext context) {
    final status = drillStatus;
    final isLocked = status == "locked";

    return Opacity(
      opacity: isLocked ? 0.6 : 1,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              child: CachedNetworkImage(
                imageUrl: widget.drill.img,
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.appBGColor,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Image.asset(
                      AppImageStrings.profileImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
              ),
            ),

            /// --- Description
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  widget.drill.description,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.boldTextColor,
                  ),
                ),
              ),
            ),

            /// --- Status / Action section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildBottomSection(status, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(String status, BuildContext context) {
    switch (status) {
      case "completed":
        return Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                "Completed ✅",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );

      case "awaiting":
        return Row(
          children: [
            const Icon(
              Icons.hourglass_bottom,
              color: AppColors.lightBackgroundGradient,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                "Awaiting approval",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.appPrimaryColor,
                ),
              ),
            ),
          ],
        );

      case "rejected":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Rejected ❌ — Please resubmit",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSubmissionField(context),
          ],
        );

      case "locked":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Locked 🔒 — You need your previous drill to be approved before submitting this one.",
                softWrap: true,
                overflow: TextOverflow.visible,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        );

      case "active":
      default:
        return _buildSubmissionField(context);
    }
  }

  Widget _buildSubmissionField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextFormField(
            obscure: false,
            textController: _drillLinkController,
            hintText: "Enter drill link",
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 80.w,
          child: AppButton(
            label: "Submit",
            backgroundColor: AppColors.darkBackButton,
            textColor: AppColors.whiteColor,
            onButtonPressed:
                () => widget.onSubmit(_drillLinkController.text.trim()),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _drillLinkController.dispose();
    super.dispose();
  }
}