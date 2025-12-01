import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: getScreenHeight(context, 0.1),
        leading: AppBackButton(),
      ),
      body: DarkBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_sharp,
                size: getScreenHeight(context, 0.1),
                color: AppColors.whiteColor,
              ),
              SizedBox(height: getScreenHeight(context, 0.03)),
              Text(
                'This page does not exist',
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
