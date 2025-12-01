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
import 'package:next_kick/features/auth/views/reset_password_view.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class SendEmailForOtpView extends StatefulWidget {
  static const routeName = '/send-email-for-otp';
  const SendEmailForOtpView({super.key});

  @override
  State<StatefulWidget> createState() => _SendEmailForOtpViewState();
}

class _SendEmailForOtpViewState extends State<SendEmailForOtpView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        MailSubmittedOnForgotPassword(email: _emailController.text.trim()),
      );
      Navigator.pushNamed(
        context,
        ResetPasswordView.routeName,
        arguments: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, otpState) {
        if (otpState is ForgotPasswordFailure) {
          AppToast.show(
            context,
            message: otpState.error,
            style: ToastStyle.error,
          );
        }
        if (otpState is ForgotPasswordSuccessful) {
          AppToast.show(
            context,
            message: otpState.message,
            style: ToastStyle.success,
          );
          Navigator.pushNamed(
            context,
            ResetPasswordView.routeName,
            arguments: _emailController.text.trim(),
          );
        }
      },
      builder: (context, otpState) {
        final scaffoldContent = Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80.w,
            toolbarHeight: 40.h,
            leading: AppBackButton(),
          ),

          body: DarkBackground(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        AppTextStrings.resetPassword,

                        style: context.textTheme.displayLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    SizedBox(height: getScreenHeight(context, 0.028)),
                    LabelAndTextField(
                      label: AppTextStrings.email,
                      textController: _emailController,
                      hintText: AppTextStrings.email,
                      obscure: false,
                      validator:
                          (value) => validateEmail(
                            value: value,
                            fieldName: AppTextStrings.email,
                          ),
                    ),

                    SizedBox(height: getScreenHeight(context, 0.02)),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: getScreenWidth(context, 0.5),
                        child: AppButton(
                          onButtonPressed: () => _submitForm(),

                          label: AppTextStrings.getOtp,
                          backgroundColor: AppColors.whiteColor,
                          textColor: AppColors.darkBackButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        if (otpState is ForgotPasswordLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }
}
