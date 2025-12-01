import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PlayerStandingsBox extends StatelessWidget {
  const PlayerStandingsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430.h,
      width: 270.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: [
            AppColors.darkBackgroundGradient,
            AppColors.lightBackgroundGradient,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 3,
            offset: Offset(5, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          Text(
            AppTextStrings.standings,
            style: context.textTheme.displayLarge?.copyWith(
              fontSize: 36,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(height: 10.h),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(6),
                            fillColor: AppColors.lightBackgroundColor,

                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
