import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_drop_down_widget.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/features/auth/bloc/auth_bloc.dart';
import 'package:next_kick/features/auth/bloc/auth_event.dart';
import 'package:next_kick/features/auth/bloc/auth_state.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_list/countries_list.dart';
import 'package:next_kick/utilities/constants/app_list/player_positions_list.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/image_picker.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class UploadPictureView extends StatefulWidget {
  final PlayerModel player;
  final String password;
  final String confirmPassword;

  static const routeName = '/upload-picture';
  const UploadPictureView({
    super.key,
    required this.player,
    required this.password,
    required this.confirmPassword,
  });

  @override
  State<StatefulWidget> createState() => _UploadPictureViewState();
}

class _UploadPictureViewState extends State<UploadPictureView> {
  final TextEditingController _countryController = TextEditingController();
  final ValueNotifier<File?> _profileImage = ValueNotifier<File?>(null);
  final TextEditingController _positionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_profileImage.value == null) {
      AppToast.show(
        context,
        message: 'Please upload a profile picture',
        style: ToastStyle.warning,
      );
      return;
    }
    if (_countryController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please select your country',
        style: ToastStyle.warning,
      );
      return;
    }

    // Validate position
    if (_positionController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please select your playing position',
        style: ToastStyle.warning,
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      debugPrint('Picked image path: ${_profileImage.value?.path}');
      BlocProvider.of<AuthBloc>(context).add(
        PlayerDetailsSubmitted(
          player: widget.player.copyWith(
            country: _countryController.text.trim(),
            playerPosition: _positionController.text.trim(),
          ),
          profilePicture: _profileImage.value,

          password: widget.password,
          confirmPassword: widget.confirmPassword,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is PlayerSignUpFailure) {
          AppToast.show(
            context,
            message: authState.error,
            style: ToastStyle.error,
          );
        } else if (authState is PlayerSignUpSuccessful) {
          AppToast.show(
            context,
            message: 'Successfully Signed Up',
            style: ToastStyle.success,
          );
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        }
      },
      builder: (context, authState) {
        final scaffoldContent = Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80.w,
            toolbarHeight: 40.h,
            leading: AppBackButton(),
          ),
          body: DarkBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: StaggeredColumn(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          staggerType: StaggerType.slide,
                          slideAxis: SlideAxis.vertical,
                          children: [
                            SizedBox(height: 70.h),

                            Center(
                              child: Text(
                                AppTextStrings.signUp,
                                style: context.textTheme.displayLarge?.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            ValueListenableBuilder(
                              valueListenable: _profileImage,
                              builder: (context, image, child) {
                                return CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      image == null
                                          ? AssetImage(
                                                AppImageStrings.profileImage,
                                              )
                                              as ImageProvider
                                          : FileImage(image) as ImageProvider,
                                );
                              },
                            ),
                            SizedBox(height: getScreenHeight(context, 0.02)),

                            SizedBox(
                              width: 200.w,
                              child: AppButton(
                                onButtonPressed: () {
                                  ImagePickerHelper.pickInto(_profileImage);
                                },
                                label: AppTextStrings.uploadPicture,
                                backgroundColor: AppColors.whiteColor,
                                textColor: AppColors.darkBackButton,
                              ),
                            ),
                            SizedBox(height: 15.h),

                            AppDropDownWidget(
                              validatorName: AppTextStrings.country,
                              label: AppTextStrings.country,
                              dropDownList: countriesList,
                              controller: _countryController,
                            ),
                            SizedBox(height: getScreenHeight(context, 0.015)),

                            AppDropDownWidget(
                              label: AppTextStrings.playerPositionUpperCase,
                              dropDownList: playerPositions,
                              validatorName: AppTextStrings.playerPosition,
                              controller: _positionController,
                            ),

                            SizedBox(height: getScreenHeight(context, 0.015)),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 20, bottom: 20),
                                child: SizedBox(
                                  width: getScreenWidth(context, 0.23),
                                  child: AppButton(
                                    onButtonPressed: () => _submitForm(),

                                    label: AppTextStrings.signUp,
                                    backgroundColor: AppColors.whiteColor,
                                    textColor: AppColors.darkBackButton,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        if (authState is PlayerSignUpLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _positionController.dispose();
    _profileImage.dispose();
    super.dispose();
  }
}
