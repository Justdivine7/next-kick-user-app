import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_confirmation_dialog.dart';
import 'package:next_kick/common/widgets/app_settings_button.dart';
import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/features/notification/notification_list_view.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';

class TeamSettingsView extends StatelessWidget {
  static const routeName = '/team_settings';
  const TeamSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80.w,
        toolbarHeight: 40.h,
        leading: AppBackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImageStrings.settings),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: NextKickLightBackground(
        alignment: Alignment.center,

        image: AppImageStrings.lightSphere,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: StaggeredColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              staggerType: StaggerType.slide,
              slideAxis: SlideAxis.vertical,
              children: [
                SizedBox(height: 100.h),
                AppSettingsButton(
                  onButtonPressed: () {
                    Navigator.pushNamed(context, NotificationListView.routeName);
                  },
                  padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
                  label: AppTextStrings.notifications,
                  backgroundColor: AppColors.darkBackButton,
                  textColor: AppColors.whiteColor,
                  fontSize: 40,
                ),
                SizedBox(height: 10.h),
                AppSettingsButton(
                  padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
                  label: AppTextStrings.logout,
                  backgroundColor: AppColors.darkBackButton,
                  textColor: AppColors.whiteColor,
                  fontSize: 40,
                  onButtonPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return AppConfirmationBottomSheet(
                          title: 'Logout?',
                          content: 'Are you sure you want to logout?',
                          confirmText: 'Logout',
                          onConfirm: () async {
                            await getIt<AppLocalStorageService>().logout();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                LoginView.routeName,
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
        ),
      ),
    );
  }
}
