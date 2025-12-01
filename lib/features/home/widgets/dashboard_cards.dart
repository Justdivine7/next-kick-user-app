import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
 import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class DashboardCards extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardList;
  const DashboardCards({super.key, required this.dashboardList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dashboardList.length,
        itemBuilder: (context, index) {
          final view = dashboardList[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, view['route']);
            },
            child: Container(
              width: 230.w,
              margin: EdgeInsets.only(right: 16.w),
              child: NextKickLightBackground(
                alignment: Alignment.center,
                image: AppImageStrings.lightSphere,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30.w,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        view['title'],
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.boldTextColor,
                        ),
                      ),

                      SizedBox(
                        height: 210.h,
                        child: Image.asset(
                          view['big-image'],
                          fit: BoxFit.contain,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            view['action-text'],
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.boldTextColor,
                            ),
                          ),
                          SizedBox(width: 5.w),

                          if (view['small-image'] != '')
                            Image.asset(
                              view['small-image'],
                              width: 60.w,
                              height: 60.h,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
