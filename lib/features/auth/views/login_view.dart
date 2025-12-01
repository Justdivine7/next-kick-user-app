import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/exit_alert.dart';
import 'package:next_kick/common/widgets/label_and_text_field.dart';
import 'package:next_kick/features/auth/bloc/auth_bloc.dart';
import 'package:next_kick/features/auth/bloc/auth_event.dart';
import 'package:next_kick/features/auth/bloc/auth_state.dart';
import 'package:next_kick/features/auth/views/player_or_team_signup_view.dart';
import 'package:next_kick/features/auth/views/send_email_for_otp_view.dart';
import 'package:next_kick/features/player/dashboard/player_dashboard_view.dart';
import 'package:next_kick/features/team/dashboard/team_dashboard_view.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> showPassword = ValueNotifier<bool>(true);

  void _submitForm() {
    FocusScope.of(context).unfocus();
    final password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      if (password.length < 6) {
        AppToast.show(
          context,
          message: 'Password must be at least 6 characters',
          style: ToastStyle.warning,
        );
        return;
      }
      BlocProvider.of<AuthBloc>(context).add(
        LoginDetailsSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, loginState) {
        if (loginState is LoginFailure) {
          AppToast.show(
            context,
            message: loginState.error,
            style: ToastStyle.error,
          );
        }
        if (loginState is LoginSuccessful) {
          AppToast.show(
            context,
            message: 'Login Successful',
            style: ToastStyle.success,
          );
          loginState.isPlayer
              ? Navigator.pushReplacementNamed(
                context,
                PlayerDashboardView.routeName,
              )
              : Navigator.pushReplacementNamed(
                context,
                TeamDashboardView.routeName,
              );
        }
      },
      builder: (context, loginState) {
        final scaffoldContent = PopScope(
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
            resizeToAvoidBottomInset: false,

            body: DarkBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 55.w,

                              height: 70.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImageStrings.mainLogo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppTextStrings.login,
                              style: context.textTheme.displayLarge?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            padding: EdgeInsets.all(25),

                            width: getScreenWidth(context, 0.8),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelAndTextField(
                                  label: AppTextStrings.email,
                                  labelColor: AppColors.boldTextColor,
                                  textController: _emailController,
                                  hintText: AppTextStrings.email,
                                  obscure: false,
                                  errorColor: AppColors.boldTextColor,
                                  errorBorder: BorderSide(
                                    color: AppColors.boldTextColor,
                                  ),
                                  validator:
                                      (value) => validateEmail(
                                        value: value,
                                        fieldName: AppTextStrings.email,
                                      ),
                                ),

                                SizedBox(height: 15.h),

                                ValueListenableBuilder<bool>(
                                  valueListenable: showPassword,
                                  builder: (context, value, child) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: LabelAndTextField(
                                        label: AppTextStrings.password,
                                        labelColor: AppColors.boldTextColor,
                                        textController: _passwordController,
                                        hintText: AppTextStrings.password,
                                        obscure: value,
                                        errorColor: AppColors.boldTextColor,
                                        errorBorder: BorderSide(
                                          color: AppColors.boldTextColor,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            showPassword.value =
                                                !showPassword.value;
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
                                              fieldName:
                                                  AppTextStrings.password,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  onButtonPressed: () => _submitForm(),
                                  label: AppTextStrings.login,
                                  backgroundColor: AppColors.darkBackButton,
                                  textColor: AppColors.whiteColor,
                                ),
                                SizedBox(height: 18.h),
                                GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    _passwordController.clear();
                                    Navigator.pushNamed(
                                      context,
                                      SendEmailForOtpView.routeName,
                                    );
                                  },
                                  child: Text(
                                    AppTextStrings.forgotPassword,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(
                                          decoration: TextDecoration.underline,
                                          color: AppColors.boldTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  PlayerOrTeamSignupView.routeName,
                                ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppTextStrings.dontHaveAnAccount,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  AppTextStrings.signUp.capitalizeFirstLetter(),

                                  style: context.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.whiteColor,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (loginState is LoginLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
