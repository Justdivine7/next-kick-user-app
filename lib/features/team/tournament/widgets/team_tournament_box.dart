import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class TeamTournamentBox extends StatelessWidget {
  const TeamTournamentBox({super.key});

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
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 5, // How much the shadow spreads (expands)
            blurRadius: 3, // How blurred the shadow is
            offset: Offset(5, 6), // X, Y offset from the container
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          Text(
            AppTextStrings.fixtures,
            style: context.textTheme.displayLarge?.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(height: 10.h),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none,
                          right: BorderSide.none,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkBackgroundGradient,
                            AppColors.lightBackgroundGradient,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ), // Shadow color
                            spreadRadius:
                                5, // How much the shadow spreads (expands)
                            blurRadius: 3, // How blurred the shadow is
                            offset: Offset(
                              0,
                              6,
                            ), // X, Y offset from the container
                          ),
                        ],
                      ),
                      child: Text(
                        'TEAM FC',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Container(
                      width: 60,
                      height: 60,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightLogoBorder,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ), // Shadow color
                            spreadRadius:
                                5, // How much the shadow spreads (expands)
                            blurRadius: 3, // How blurred the shadow is
                            offset: Offset(
                              0,
                              6,
                            ), // X, Y offset from the container
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppImageStrings.darkSphere,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkBackgroundGradient,
                            AppColors.lightBackgroundGradient,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ), // Shadow color
                            spreadRadius:
                                5, // How much the shadow spreads (expands)
                            blurRadius: 3, // How blurred the shadow is
                            offset: Offset(
                              0,
                              6,
                            ), // X, Y offset from the container
                          ),
                        ],
                      ),
                      child: Text(
                        'TEAM FC',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
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
