import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/field_and_validator.dart';
import 'package:next_kick/common/widgets/password_field_widget.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/data/models/upload_picture_args.dart';
import 'package:next_kick/features/auth/views/login_view.dart';

import 'package:next_kick/features/auth/views/upload_picture_view.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class PlayerSignUpView extends StatefulWidget {
  static const routeName = '/signup';

  const PlayerSignUpView({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerSignUpViewState();
}

class _PlayerSignUpViewState extends State<PlayerSignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> showPassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> showConfirmPassword = ValueNotifier<bool>(true);

  void _submitForm() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

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

    Navigator.pushNamed(
      context,
      UploadPictureView.routeName,
      arguments: UploadPictureArgs(
        player: PlayerModel.fromMinimalDetails(
          email: _emailController.text.trim(),
          userType: 'player',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          height: _heightController.text.trim(),
        ),
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // extendBodyBehindAppBar: true,
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
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: StaggeredColumn(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                staggerType: StaggerType.slide,
                slideAxis: SlideAxis.vertical,
                children: [
                  // SizedBox(height: getScreenHeight(context, 0.13)),

                  Center(
                    child: Text(
                      AppTextStrings.signUp,

                      style: context.textTheme.displayLarge?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  SizedBox(height: getScreenHeight(context, 0.028)),
                  FieldAndValidator(
                    fieldName: AppTextStrings.firstName,
                    textController: _firstNameController,
                    obscure: false,
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  FieldAndValidator(
                    fieldName: AppTextStrings.lastName,
                    textController: _lastNameController,
                    obscure: false,
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  FieldAndValidator(
                    fieldName: AppTextStrings.emailAddress,
                    textController: _emailController,
                    isEmail: true,
                    obscure: false,
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  PasswordFieldWidget(
                    showPassword: showPassword,
                    passwordController: _passwordController,
                    fieldName: AppTextStrings.password,
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  PasswordFieldWidget(
                    showPassword: showConfirmPassword,
                    passwordController: _confirmPasswordController,
                    fieldName: AppTextStrings.confirmPassword,
                    hintText: AppTextStrings.password,
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  FieldAndValidator(
                    fieldName: AppTextStrings.age,
                    textController: _ageController,
                    obscure: false,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  FieldAndValidator(
                    fieldName: AppTextStrings.heightInches,
                    textController: _heightController,
                    obscure: false,
                    hintText: AppTextStrings.height,
                    keyboardType: TextInputType.numberWithOptions(),
                  ),

                  SizedBox(height: getScreenHeight(context, 0.013)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: getScreenWidth(context, 0.3),
                      child: AppButton(
                        onButtonPressed: () => _submitForm(),
                        label: AppTextStrings.next,
                        backgroundColor: AppColors.whiteColor,
                        textColor: AppColors.darkButtonColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap:
                        () => Navigator.pushNamed(context, LoginView.routeName),
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
                            fontWeight: FontWeight.w500,
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
