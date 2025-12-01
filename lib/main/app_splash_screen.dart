import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/main/app_route_decision_maker.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';

class AppSplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  bool _showContent = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRouteDecisionMaker.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double slideOffset = _showContent ? 0 : screenSize.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.darkBackgroundGradient,
              AppColors.lightBackgroundGradient,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(slideOffset, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      AppImageStrings.mainLogo,
                      width: 150.w,
                      height: 200.h,
                      fit: BoxFit.contain,
                    ),

                    Image.asset(
                      AppImageStrings.binalSportsLogo,
                      width: 40.w,
                      height: 30.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
