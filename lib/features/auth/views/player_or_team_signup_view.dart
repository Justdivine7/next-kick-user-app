import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/bold_text_with_details.dart';
import 'package:next_kick/common/widgets/dark_background.dart';
import 'package:next_kick/common/widgets/exit_alert.dart';
import 'package:next_kick/features/auth/views/player_sign_up_view.dart';
import 'package:next_kick/features/auth/views/team_signup_view.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PlayerOrTeamSignupView extends StatelessWidget {
  static const String routeName = '/player_or_team_signup';
  const PlayerOrTeamSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
         canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ExitAlert(),
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: DarkBackground(
          child: SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 50.h),
                Text(
                  AppTextStrings.signUp,
                  style: context.textTheme.displayLarge?.copyWith(
                    color: AppColors.appBGColor,
                  ),
                ),
                SizedBox(height: 90.h),

                BoldTextWithDetails(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  onTap: () {
                    Navigator.pushNamed(context, PlayerSignUpView.routeName);
                  },
                  label: AppTextStrings.player,
                  details: AppTextStrings.trainAndFollowTournament,
                  backgroundColor: AppColors.appBGColor,
                  labelColor: AppColors.boldTextColor,
                  detailsTextColor: AppColors.appBGColor,
                ),
                SizedBox(height: 50.h),

                BoldTextWithDetails(
                  onTap: () {
                    Navigator.pushNamed(context, TeamSignupView.routeName);
                  },
                  padding: EdgeInsets.symmetric(vertical: 34, horizontal: 26),
                  label: AppTextStrings.team,
                  details: AppTextStrings.enterAndFollowTournament,
                  backgroundColor: AppColors.appBGColor,
                  labelColor: AppColors.boldTextColor,
                  detailsTextColor: AppColors.appBGColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
