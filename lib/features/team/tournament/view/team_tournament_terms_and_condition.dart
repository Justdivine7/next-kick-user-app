import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/next_kick_dark_background.dart';
import 'package:next_kick/features/team/tournament/bloc/tournament_bloc.dart';
import 'package:next_kick/data/models/tournament_model.dart';
import 'package:next_kick/features/team/tournament/view/team_pay_amount.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class TeamTournamentTermsAndCondition extends StatelessWidget {
  static const routeName = '/tournament_detail_card';
  final TournamentModel tournament;

  const TeamTournamentTermsAndCondition({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TournamentBloc, TournamentState>(
      listener: (context, state) {
        if (state is RegisterForTournamentSuccessful) {
          final paymentUrl = state.message;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TeamPayAmount(url: paymentUrl)),
          );
        }

        if (state is RegisterForTournamentError) {
          return AppToast.show(
            context,
            message: state.errorMessage,
            style: ToastStyle.error,
          );
        }
      },
      child: BlocBuilder<TournamentBloc, TournamentState>(
        builder: (context, state) {
          final isLoading = state is RegisterForTournamentLoading;
          return Stack(
            children: [
              Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leadingWidth: 80.w,
                  toolbarHeight: 40.h,
                  leading: const AppBackButton(),
                ),
                body: NextKickDarkBackground(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Tournament Details',
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Tournament Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: AppColors.darkBackgroundGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    tournament.title?.capitalizeFirstLetter() ??
                                        'No Title',
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(color: AppColors.whiteColor),
                                  ),
                                  SizedBox(height: 12.h),

                                  // Location
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.appBGColor,
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          tournament.location
                                                  ?.capitalizeFirstLetter() ??
                                              'Unknown location',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: AppColors.appBGColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),

                                  // Description
                                  Text(
                                    'Description',
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(color: AppColors.whiteColor),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    tournament.description
                                            ?.capitalizeFirstLetter() ??
                                        'No description available.',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(color: AppColors.whiteColor),
                                  ),
                                  SizedBox(height: 30.h),

                                  // Pay Button
                                  Center(
                                    child: AppButton(
                                      label: 'Pay with Bank Transfer',
                                      backgroundColor: AppColors.appBGColor,
                                      textColor: AppColors.boldTextColor,
                                      onButtonPressed:
                                          () => context
                                              .read<TournamentBloc>()
                                              .add(
                                                RegisterForTournaments(
                                                  tournamentId: tournament.id!,
                                                ),
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading) Positioned.fill(child: AppLoadingOverlay()),
            ],
          );
        },
      ),
    );
  }
}
