import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';

class PlayerCongratulationsView extends StatefulWidget {
  static const routeName = '/congratulations';
  const PlayerCongratulationsView({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerCongratulationsViewState();
}

class _PlayerCongratulationsViewState extends State<PlayerCongratulationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70.w,
        leading: AppBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: NextKickLightBackground(
            image: AppImageStrings.nextKickLightLogo,
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    AppTextStrings.congratulations,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    AppTextStrings.youHaveSkilledUp,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImageStrings.nextKickTrophy),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
