import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/animated_pulsing_image.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/empty_state.dart';
import 'package:next_kick/common/widgets/error_and_reload_widget.dart';
import 'package:next_kick/common/widgets/pull_to_refresh.dart';
import 'package:next_kick/common/widgets/shimmer_loading_overlay.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/features/player/drills/bloc/drill_bloc.dart';
import 'package:next_kick/features/player/widgets/drill_widget.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/shimmer_enum.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PlayerDrillView extends StatefulWidget {
  static const routeName = '/drills';
  const PlayerDrillView({super.key});

  @override
  State<PlayerDrillView> createState() => _PlayerDrillViewState();
}

class _PlayerDrillViewState extends State<PlayerDrillView> {
  final AppLocalStorageService _localStorage = getIt<AppLocalStorageService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PlayerModel? _cachedPlayer;

  void _submitDrillLink(String drillId, String link) {
    FocusScope.of(context).unfocus();

    if (link.isEmpty) {
      AppToast.show(
        context,
        message: 'Please enter a drill link',
        style: ToastStyle.warning,
      );
      return;
    }

    if (!link.startsWith('http://') && !link.startsWith('https://')) {
      AppToast.show(
        context,
        message: 'Please enter a valid HTTP link',
        style: ToastStyle.warning,
      );
      return;
    }

    context.read<DrillBloc>().add(
      SubmitDrill(drillId: drillId, submissionLink: link.trim()),
    );
  }

  void _loadPlayerData() {
    try {
      _cachedPlayer = _localStorage.getPlayerUser();
    } catch (e) {
      debugPrint('Error loading cached user: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
    context.read<DrillBloc>().add(FetchPlayerDrills());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrillBloc, DrillState>(
      listener: (context, drillState) {
        if (drillState is DrillError || drillState is LevelCompletionError) {
          AppToast.show(
            context,
            message: (drillState as dynamic).message,
            style: ToastStyle.error,
          );
        }
        if (drillState is DrillSubmissionError) {
          AppToast.show(
            context,
            message: (drillState as dynamic).message,
            style: ToastStyle.error,
          );
        }

        if (drillState is DrillSubmitted) {
          AppToast.show(
            context,
            message: drillState.message,
            style: ToastStyle.success,
          );
          // Refresh drills after successful submission
          context.read<DrillBloc>().add(FetchPlayerDrills());
        } else if (drillState is LevelCompleted) {
          AppToast.show(
            context,
            message: drillState.message,
            style: ToastStyle.success,
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, drillState) {
        if (drillState is DrillLoading) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: const AppBackButton(),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Text(
                    '[${_cachedPlayer?.activeBundle.capitalizeFirstLetter() ?? ''}]',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.boldTextColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: AnimatedPulsingImage(
                imagePath: AppImageStrings.nextKickDarkLogo,
              ),
            ),
          );
        }

        if (drillState is DrillError) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: const AppBackButton(),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Text(
                    '[${_cachedPlayer?.activeBundle.capitalizeFirstLetter() ?? ''}]',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.boldTextColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            body: ErrorAndReloadWidget(
              errorTitle: 'Drills not found',
              errorDetails: 'Refresh the page to try again.',
              buttonPressed: () {
                context.read<DrillBloc>().add(FetchPlayerDrills());
              },
            ),
          );
        }

        // Calculate canComplete at the builder level
        bool canComplete = false;
        if (drillState is DrillLoaded || drillState is DrillSubmissionError) {
          final drills =
              drillState is DrillLoaded
                  ? drillState.drills
                  : (drillState as DrillSubmissionError).drills;

          canComplete =
              drills.isNotEmpty &&
              drills.every(
                (d) =>
                    d.isCompleted == true &&
                    d.isApproved == true &&
                    d.isRejected == false,
              );
        }

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.lightBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leadingWidth: 80.w,
                toolbarHeight: 40.h,
                leading: const AppBackButton(),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: Text(
                      '[${_cachedPlayer?.activeBundle.capitalizeFirstLetter() ?? ''}]',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.boldTextColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.all(16.w),
                child: Builder(
                  builder: (context) {
                    // Handle both DrillLoaded and DrillSubmissionError states
                    final drills =
                        drillState is DrillLoaded
                            ? drillState.drills
                            : drillState is DrillSubmissionError
                            ? (drillState).drills
                            : null;

                    if (drills != null && drills.isEmpty) {
                      return EmptyState(
                        image: AppImageStrings.nextKickDarkLogo,
                        notifierText: 'No drills available',
                        descriptionText:
                            "You don't have any drills at the moment.",
                      );
                    }

                    if (drills != null) {
                      return Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: PullToRefresh(
                            onRefresh: () async {
                              context.read<DrillBloc>().add(
                                FetchPlayerDrills(),
                              );
                            },
                            child: StaggeredColumn(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              staggerType: StaggerType.slide,
                              slideAxis: SlideAxis.vertical,
                              children: [
                                for (final drill in drills)
                                  DrillWidget(
                                    drill: drill,
                                    onSubmit: (link) {
                                      if (!drill.canAttempt) {
                                        AppToast.show(
                                          context,
                                          message:
                                              "You can't submit this drill yet. Complete the previous one first.",
                                          style: ToastStyle.error,
                                        );
                                        return;
                                      }
                                      _submitDrillLink(
                                        drill.id.toString(),
                                        link,
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // Show empty container for other states (like DrillSubmittedLoading)
                    return Container();
                  },
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  height: 60,
                  child: AppButton(
                    label: AppTextStrings.complete,
                    backgroundColor:
                        canComplete
                            ? AppColors.darkBackButton
                            : Colors.grey.shade400,
                    textColor: AppColors.whiteColor,
                    onButtonPressed:
                        canComplete
                            ? () {
                              context.read<DrillBloc>().add(CompleteLevel());
                            }
                            : () {
                              AppToast.show(
                                context,
                                message:
                                    "You must complete and get all drills approved first.",
                                style: ToastStyle.error,
                              );
                            },
                  ),
                ),
              ),
            ),
            // Overlay shows during initial loading or submission
            if (drillState is DrillLoading)
              Positioned.fill(
                child: const ShimmerLoadingOverlay(
                  pageType: ShimmerEnum.drills,
                ),
              ),
            if (drillState is DrillSubmittedLoading)
              Positioned.fill(child: const AppLoadingOverlay()),
          ],
        );
      },
    );
  }
}
