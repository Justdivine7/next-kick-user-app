import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_drop_down_widget.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_select_image_icon.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/field_and_validator.dart';
import 'package:next_kick/common/widgets/shimmer_loading_overlay.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/features/user/bloc/user_bloc.dart';
import 'package:next_kick/features/user/bloc/user_event.dart';
import 'package:next_kick/features/user/bloc/user_state.dart';
import 'package:next_kick/utilities/constants/app_list/countries_list.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/shimmer_enum.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/helpers/image_picker.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/dark_background.dart';

class PlayerProfileEditView extends StatefulWidget {
  static const routeName = '/profile-edit';

  const PlayerProfileEditView({super.key});

  @override
  State<PlayerProfileEditView> createState() => _PlayerProfileEditViewState();
}

class _PlayerProfileEditViewState extends State<PlayerProfileEditView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<File?> _profileImage = ValueNotifier<File?>(null);

  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _countryController;

  PlayerModel? _cachedPlayer;
  bool _isFormInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadCachedPlayer();
    _initControllers();
  }

  void _loadCachedPlayer() {
    try {
      _cachedPlayer = getIt<AppLocalStorageService>().getPlayerUser();
    } catch (e) {
      debugPrint('⚠️ Failed to load cached player: $e');
    }
  }

  void _initControllers() {
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _countryController = TextEditingController();

    if (_cachedPlayer != null) _populateFields(_cachedPlayer!);
  }

  void _populateFields(PlayerModel player) {
    _firstNameController.text = player.firstName;
    _lastNameController.text = player.lastName;
    _emailController.text = player.email;
    _ageController.text = player.age.toString();
    _heightController.text = player.height;
    _countryController.text = player.country;
  }

  void _updateFormFields(PlayerModel user) {
    if (!_isFormInitialized) {
      _populateFields(user);
      _isFormInitialized = true;
    }
  }

  void _onUpdateProfile(PlayerModel player) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final updatedPlayer = player.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      age: int.tryParse(_ageController.text),
      height: _heightController.text.trim(),
      country: _countryController.text.trim(),
    );

    context.read<UserBloc>().add(
      UpdatePlayerProfile(
        updatedData: updatedPlayer,
        profilePicture: _profileImage.value,
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
    _countryController.dispose();
    _profileImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is PlayerProfileUpdatedError) {
          AppToast.show(
            context,
            message: state.message,
            style: ToastStyle.error,
          );
        } else if (state is PlayerProfileUpdateSuccessful) {
          AppToast.show(
            context,
            message: 'Profile updated successfully',
            style: ToastStyle.success,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        PlayerModel? player;
        bool showShimmer = false;
        bool showOverlay = false;

        switch (state) {
          case PlayerProfileLoaded s:
            player = s.user;
            _updateFormFields(s.user);
            break;

          case PlayerProfileLoading _:
            player =
                _cachedPlayer ??
                getIt<AppLocalStorageService>().getPlayerUser();
            showShimmer = player == null;
            break;

          case PlayerProfileUpdateLoading _:
            player =
                _cachedPlayer ??
                getIt<AppLocalStorageService>().getPlayerUser();
            showOverlay = true;
            break;

          default:
            player =
                _cachedPlayer ??
                getIt<AppLocalStorageService>().getPlayerUser();
        }

        if (player == null) {
          return _buildScaffold(
            context,
            const Center(child: Text('No profile data available')),
          );
        }

        return Stack(
          children: [
            _buildScaffold(context, _buildForm(context, player)),
            if (showShimmer)
              ShimmerLoadingOverlay(pageType: ShimmerEnum.drills),
            if (showOverlay) const AppLoadingOverlay(),
          ],
        );
      },
    );
  }

  Scaffold _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80.w,
        leading: const AppBackButton(),
      ),
      body: DarkBackground(child: body),
    );
  }

  Widget _buildForm(BuildContext context, PlayerModel player) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Form(
        key: _formKey,
        child: StaggeredColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          staggerType: StaggerType.slide,
          slideAxis: SlideAxis.vertical,
          children: [
            SizedBox(height: 75.h),
            _buildProfileImage(player),
            SizedBox(height: 16.h),
            _buildFormFields(player),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 100.w,
                child: AppButton(
                  onButtonPressed: () => _onUpdateProfile(player),
                  padding: EdgeInsets.all(4.h),
                  label: AppTextStrings.submit,
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.darkButtonColor,
                ),
              ),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(PlayerModel player) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ValueListenableBuilder<File?>(
          valueListenable: _profileImage,
          builder: (_, image, __) {
            return AppSelectImageIcon(
              imageFile: image,
              initialImageUrl: player.profilePicture,
            );
          },
        ),
        GestureDetector(
          onTap: () => ImagePickerHelper.pickInto(_profileImage),
          child: const Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.appBGColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(PlayerModel player) {
    return StaggeredColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      staggerType: StaggerType.slide,
      slideAxis: SlideAxis.vertical,
      children: [
        FieldAndValidator(
          fieldName: AppTextStrings.firstName,
          textController: _firstNameController,
          hintText: player.firstName,
          obscure: false,
        ),
        SizedBox(height: 16.h),
        FieldAndValidator(
          fieldName: AppTextStrings.lastName,
          textController: _lastNameController,
          hintText: player.lastName,
          obscure: false,
        ),
        SizedBox(height: 8.h),
        FieldAndValidator(
          fieldName: AppTextStrings.emailAddress,
          textController: _emailController,
          hintText: player.email,
          obscure: false,
          readOnly: true,
          textColor: AppColors.borderColor,
          onTap: () {
            AppToast.show(
              context,
              message: 'Email cannot be changed',
              style: ToastStyle.warning,
            );
          },
        ),
        SizedBox(height: 8.h),
        FieldAndValidator(
          fieldName: AppTextStrings.age,
          textController: _ageController,
          hintText: player.age.toString(),
          obscure: false,
        ),
        SizedBox(height: 8.h),
        FieldAndValidator(
          fieldName: AppTextStrings.heightInches,
          textController: _heightController,
          hintText: player.height,
          obscure: false,
        ),
        SizedBox(height: 8.h),
        AppDropDownWidget(
          validatorName: AppTextStrings.country,
          label: player.country,
          dropDownList: countriesList,
          controller: _countryController,
        ),
      ],
    );
  }
}
