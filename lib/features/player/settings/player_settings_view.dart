import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_settings_button.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/features/notification/notification_list_view.dart';
import 'package:next_kick/features/player/profile/player_profile_edit_view.dart';
import 'package:next_kick/features/player/settings/performance_video_submit_dialog.dart';
import 'package:next_kick/features/user/bloc/user_bloc.dart';
import 'package:next_kick/features/user/bloc/user_event.dart';
import 'package:next_kick/features/user/bloc/user_state.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';

class PlayerSettingsView extends StatefulWidget {
  static const routeName = '/settings';
  const PlayerSettingsView({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerSettingsViewState();
}

class _PlayerSettingsViewState extends State<PlayerSettingsView> {
  final TextEditingController _textController = TextEditingController();

  void _showPerfomanceVideoDialog(
    BuildContext context,
    PlayerModel currentPlayer,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return PerformanceVideoSubmitDialog(
          textController: _textController,
          onSubmit: (link) async {
            if (!link.startsWith('http://') && !link.startsWith('https://')) {
              AppToast.show(
                context,
                message: 'Please enter a valid HTTP link',
                style: ToastStyle.error,
              );
              return;
            }
            final updatedPlayer = currentPlayer.copyWith(
              performanceVideoLink: link,
            );
            context.read<UserBloc>().add(
              UpdatePlayerProfile(updatedData: updatedPlayer),
            );
            _textController.clear();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is PlayerProfileUpdateLoading) {
          AppToast.show(
            context,
            message: 'Updating profile...',
            style: ToastStyle.warning,
          );
        } else if (state is PlayerProfileUpdateSuccessful) {
          Navigator.of(context).pop();
          AppToast.show(
            context,
            message: 'Profile updated successfully',
            style: ToastStyle.success,
          );
        } else if (state is PlayerProfileUpdatedError) {
          AppToast.show(
            context,
            message: state.message,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, state) {
        final player =
            state is PlayerProfileLoaded
                ? state.user
                : getIt<AppLocalStorageService>().getPlayerUser()!;

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
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  AppSettingsButton(
                    onButtonPressed: () {
                      Navigator.pushNamed(
                        context,
                        NotificationListView.routeName,
                      );
                    },
                    padding: EdgeInsets.symmetric(
                      vertical: 30.w,
                      horizontal: 10.w,
                    ),
                    label: AppTextStrings.notifications,
                    backgroundColor: AppColors.darkBackButton,
                    textColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 10.h),
                  AppSettingsButton(
                    padding: EdgeInsets.symmetric(
                      vertical: 30.w,
                      horizontal: 10.w,
                    ),

                    label: AppTextStrings.videoLink,
                    backgroundColor: AppColors.darkBackButton,
                    textColor: AppColors.whiteColor,

                    onButtonPressed:
                        () => _showPerfomanceVideoDialog(context, player),
                  ),
                  SizedBox(height: 10.h),
                  AppSettingsButton(
                    onButtonPressed: () {
                      Navigator.pushNamed(
                        context,
                        PlayerProfileEditView.routeName,
                      );
                    },
                    padding: EdgeInsets.symmetric(
                      vertical: 30.w,
                      horizontal: 10.w,
                    ),

                    label: AppTextStrings.editProfile,
                    backgroundColor: AppColors.darkBackButton,
                    textColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 10.h),
                  AppSettingsButton(
                    onButtonPressed: () async {
                      await getIt<AppLocalStorageService>().logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginView.routeName,
                        (Route<dynamic> route) => false,
                      );
                    },
                    padding: EdgeInsets.symmetric(
                      vertical: 30.w,
                      horizontal: 10.w,
                    ),

                    label: AppTextStrings.logout,
                    backgroundColor: AppColors.darkBackButton,
                    textColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
