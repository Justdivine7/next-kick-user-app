import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/label_and_text_field.dart';
import 'package:next_kick/features/auth/bloc/auth_bloc.dart';
import 'package:next_kick/features/auth/bloc/auth_event.dart';
import 'package:next_kick/features/auth/bloc/auth_state.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class ResetPasswordView extends StatefulWidget {
  static const routeName = '/reset-password';
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  State<StatefulWidget> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _showNewPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _showConfirmPassword = ValueNotifier<bool>(true);
  final ValueNotifier<int> _secondsRemaining = ValueNotifier<int>(0);

  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value == 0) {
        timer.cancel();
      } else {
        _secondsRemaining.value--;
      }
    });
  }

  void _onResendCode() async {
    _startTimer();
    try {
      context.read<AuthBloc>().add(ResendCodeRequest(email: widget.email));
      AppToast.show(
        context,
        message: 'OTP has been resent successfully',
        style: ToastStyle.success,
      );
    } catch (e) {
      AppToast.show(context, message: e.toString(), style: ToastStyle.warning);
    }
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ResetPasswordRequest(
          code: _otpController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        ),
      );
      if (_newPasswordController.text != _confirmPasswordController.text) {
        AppToast.show(
          context,
          message: 'Passwords do not match',
          style: ToastStyle.warning,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, resetState) {
        if (resetState is ResetPasswordFailure) {
          AppToast.show(
            context,
            message: resetState.error,
            style: ToastStyle.error,
          );
        }
        if (resetState is ResetPasswordSuccessful) {
          AppToast.show(
            context,
            message: 'Reset Successful',
            style: ToastStyle.success,
          );
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        }
      },
      builder: (context, resetState) {
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.h),
                  
                      Center(
                        child: Text(
                          AppTextStrings.resetPassword,
                  
                          style: context.textTheme.displayLarge?.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  
                      SizedBox(height: 20.h),
                      LabelAndTextField(
                        label: AppTextStrings.otp,
                        textController: _otpController,
                        hintText: AppTextStrings.otp,
                        obscure: false,
                        keyboardType: TextInputType.number,
                        validator:
                            (value) => validateField(
                              value: value,
                              fieldName: AppTextStrings.otp,
                            ),
                      ),
                  
                      SizedBox(height: 10.h),
                      ValueListenableBuilder<bool>(
                        valueListenable: _showNewPassword,
                        builder: (context, value, child) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: LabelAndTextField(
                              label: AppTextStrings.newPassword,
                              labelColor: AppColors.whiteColor,
                              textController: _newPasswordController,
                              hintText: AppTextStrings.password,
                              obscure: value,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _showNewPassword.value =
                                      !_showNewPassword.value;
                                },
                                child: Icon(
                                  value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.borderColor,
                                ),
                              ),
                              validator:
                                  (value) => validatePassword(
                                    value: value,
                                    fieldName: AppTextStrings.password,
                                  ),
                            ),
                          );
                        },
                      ),
                  
                      SizedBox(height: 10.h),
                  
                      ValueListenableBuilder<bool>(
                        valueListenable: _showConfirmPassword,
                        builder: (context, value, child) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: LabelAndTextField(
                              label: AppTextStrings.confirmNewPassword,
                              labelColor: AppColors.whiteColor,
                              textController: _confirmPasswordController,
                              hintText: AppTextStrings.password,
                              obscure: value,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _showConfirmPassword.value =
                                      !_showConfirmPassword.value;
                                },
                                child: Icon(
                                  value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.borderColor,
                                ),
                              ),
                              validator:
                                  (value) => validatePassword(
                                    value: value,
                                    fieldName: AppTextStrings.password,
                                  ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      ValueListenableBuilder<int>(
                        valueListenable: _secondsRemaining,
                        builder: (context, seconds, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: getScreenWidth(context, 0.4),
                                child: AppButton(
                                  onButtonPressed:
                                      seconds == 0 ? _onResendCode : null,
                                  label:
                                      seconds == 0
                                          ? AppTextStrings.resendOtp
                                          : 'Resend in ${seconds}s',
                                  backgroundColor: AppColors.darkBackButton,
                                  textColor: AppColors.whiteColor,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: getScreenWidth(context, 0.4),
                                child: AppButton(
                                  onButtonPressed: _submitForm,
                                  label: AppTextStrings.resetPassword,
                                  backgroundColor: AppColors.whiteColor,
                                  textColor: AppColors.darkBackButton,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        if (resetState is ResetPasswordLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
