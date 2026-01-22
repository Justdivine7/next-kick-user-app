import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/app_drop_down_widget.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/dark_background.dart';
import 'package:next_kick/common/widgets/field_and_validator.dart';
import 'package:next_kick/common/widgets/password_field_widget.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/models/team_model.dart';
import 'package:next_kick/features/auth/bloc/auth_bloc.dart';
import 'package:next_kick/features/auth/bloc/auth_event.dart';
import 'package:next_kick/features/auth/bloc/auth_state.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_list/nigerian_state_list.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/image_picker.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';

class TeamSignupView extends StatefulWidget {
  static const routeName = 'team_signup';
  const TeamSignupView({super.key});

  @override
  State<TeamSignupView> createState() => _TeamSignupViewState();
}

class _TeamSignupViewState extends State<TeamSignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _teamAverageAgeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> showPassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> showConfirmPassword = ValueNotifier<bool>(true);
  final ValueNotifier<File?> _teamLogo = ValueNotifier<File?>(null);

  void _submitForm() {
    FocusScope.of(context).unfocus();

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_teamLogo.value == null) {
      AppToast.show(
        context,
        message: 'Please select a team logo',
        style: ToastStyle.warning,
      );
      return;
    }

    if (password.length < 6) {
      AppToast.show(
        context,
        message: 'Password must be at least 6 characters',
        style: ToastStyle.warning,
      );
      return;
    }

    if (password != confirmPassword) {
      AppToast.show(
        context,
        message: 'Passwords do not match',
        style: ToastStyle.warning,
      );
      return;
    }

    BlocProvider.of<AuthBloc>(context).add(
      TeamDetailsSubmitted(
        team: TeamModel.fromMinimalDetails(
          id: '',
          email: _emailController.text.trim(),
          teamName: _teamNameController.text.trim(),
          userType: 'team',
          ageGroup: _teamAverageAgeController.text.trim(),
          location: _locationController.text.trim(),
        ),
        password: password,
        confirmPassword: confirmPassword,
        teamLogo: _teamLogo.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is TeamSignUpFailure) {
          AppToast.show(
            context,
            message: authState.error,
            style: ToastStyle.error,
          );
        } else if (authState is TeamSignUpSuccessful) {
          AppToast.show(
            context,
            message: 'Successfully Signed Up',
            style: ToastStyle.success,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginView.routeName,
            (route) => false,
          );
        }
      },
      builder: (context, authState) {
        final scaffoldContent = Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: AppColors.darkBackgroundGradient,
            elevation: 0,
            leadingWidth: 80.w,
            toolbarHeight: 40.h,
            leading: AppBackButton(),
          ),
          body: DarkBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: StaggeredColumn(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    staggerType: StaggerType.slide,
                    slideAxis: SlideAxis.vertical,
                    children: [
                      SizedBox(height: getScreenHeight(context, 0.13)),

                      Center(
                        child: Text(
                          AppTextStrings.signUp,

                          style: context.textTheme.displayLarge?.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ValueListenableBuilder<File?>(
                            valueListenable: _teamLogo,
                            builder: (_, image, __) {
                              return CircleAvatar(
                                radius: 30,
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
                          SizedBox(width: 10),
                          SizedBox(
                            width: getScreenWidth(context, 0.3),
                            child: AppButton(
                              onButtonPressed:
                                  () => ImagePickerHelper.pickInto(_teamLogo),
                            
                              label: 'Add image',
                              backgroundColor: AppColors.whiteColor,
                              textColor: AppColors.darkButtonColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: getScreenHeight(context, 0.028)),
                      FieldAndValidator(
                        fieldName: AppTextStrings.teamName,
                        textController: _teamNameController,
                        obscure: false,
                      ),
                      SizedBox(height: getScreenHeight(context, 0.015)),
                      FieldAndValidator(
                        fieldName: AppTextStrings.emailAddress,
                        textController: _emailController,
                        obscure: false,
                        isEmail: true,
                      ),
                      SizedBox(height: getScreenHeight(context, 0.015)),
                      PasswordFieldWidget(
                        showPassword: showPassword,
                        passwordController: _passwordController,
                        fieldName: AppTextStrings.password,
                      ),

                      SizedBox(height: getScreenHeight(context, 0.015)),
                      PasswordFieldWidget(
                        showPassword: showConfirmPassword,
                        passwordController: _confirmPasswordController,
                        fieldName: AppTextStrings.confirmPassword,
                        hintText: AppTextStrings.password,
                      ),
                      SizedBox(height: getScreenHeight(context, 0.015)),
                      FieldAndValidator(
                        fieldName: AppTextStrings.ageGroup,
                        textController: _teamAverageAgeController,
                        obscure: false,
                        keyboardType: TextInputType.number,
                      ),
                      AppDropDownWidget(
                        label: AppTextStrings.teamLocation,
                        dropDownList: nigeriaStates,
                        validatorName: AppTextStrings.teamLocation,
                        controller: _locationController,
                      ),

                      SizedBox(height: getScreenHeight(context, 0.015)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: getScreenWidth(context, 0.3),
                          child: AppButton(
                            onButtonPressed: () => _submitForm(),

                            label: AppTextStrings.signUp,
                            backgroundColor: AppColors.whiteColor,
                            textColor: AppColors.darkButtonColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              LoginView.routeName,
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppTextStrings.alreadyHaveAnAccount,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              AppTextStrings.login.capitalizeFirstLetter(),

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

                      SizedBox(height: getScreenHeight(context, 0.05)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        if (authState is TeamSignUpLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }
}
