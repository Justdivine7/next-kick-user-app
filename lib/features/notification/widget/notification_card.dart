import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/data/models/notification_model.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.darkBackButton),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title.capitalizeFirstLetter(),
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.boldTextColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.message.capitalizeFirstLetter(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.boldTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
