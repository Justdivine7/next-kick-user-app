import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class DashboardUserDetails extends StatelessWidget {
  final PlayerModel player;
  const DashboardUserDetails({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppTextStrings.hello} [${player.firstName.capitalizeFirstLetter()} ${player.lastName}]',
          style: context.textTheme.displaySmall?.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(height: 6.h),

        Text(
          '${AppTextStrings.position}: [${player.playerPosition.capitalizeFirstLetter()}]',
          style: context.textTheme.titleSmall?.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(height: 6.h),

        Text(
          '${AppTextStrings.level}: [${player.activeBundle.capitalizeFirstLetter()}]',
          style: context.textTheme.titleSmall?.copyWith(
            color: AppColors.whiteColor,
          ),
        ),

        SizedBox(height: 6.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final double progress = (player.progress) / 100;

            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  width: constraints.maxWidth * progress,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          children: [
            Text(
              AppTextStrings.progress,
              style: context.textTheme.titleSmall?.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '${player.progress}%',
              style: context.textTheme.titleSmall?.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
