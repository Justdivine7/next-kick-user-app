import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
 import 'package:next_kick/common/widgets/dark_background.dart';
import 'package:next_kick/features/team/tournament/view/team_tournament_list_view.dart';

class PaymentSuccessView extends StatelessWidget {
  static const routeName = '/payment-success';
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: getScreenHeight(context, 0.1),
        leading: SizedBox.shrink()
      ),
      body: DarkBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: getScreenHeight(context, 0.12),
                  color: AppColors.whiteColor,
                ),
                SizedBox(height: getScreenHeight(context, 0.03)),
                Text(
                  'Payment Successful!',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,

                  'Thank you for your payment. You will be added to the tournament soon.',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.boldTextColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: getScreenHeight(context, 0.05),
                      vertical: getScreenHeight(context, 0.02),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      TeamTournamentListView.routeName,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Go to Tournaments',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
