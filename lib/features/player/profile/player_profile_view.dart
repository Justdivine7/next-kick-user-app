import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/common/widgets/error_and_reload_widget.dart';
import 'package:next_kick/common/widgets/pull_to_refresh.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/common/widgets/video_webview_page.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/features/user/bloc/user_bloc.dart';
import 'package:next_kick/features/user/bloc/user_event.dart';
import 'package:next_kick/features/user/bloc/user_state.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PlayerProfileView extends StatefulWidget {
  static const routeName = '/profile';
  const PlayerProfileView({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerProfileViewState();
}

class _PlayerProfileViewState extends State<PlayerProfileView> {
  final AppLocalStorageService _localStorage = getIt<AppLocalStorageService>();
  final TextEditingController textController = TextEditingController();
  PlayerModel? _cachedPlayer;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchPlayerProfile());

    _loadPlayerData();
    debugPrint('this is ${_cachedPlayer?.firstName}');
  }

  void _loadPlayerData() {
    try {
      _cachedPlayer = _localStorage.getPlayerUser();
    } catch (e) {
      debugPrint('Error loading cached user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80.w,
        toolbarHeight: 40.h,
        leading: AppBackButton(),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, playerState) {
          if (playerState is PlayerProfileError) {
            AppToast.show(
              context,
              message: playerState.message,
              style: ToastStyle.error,
            );
          }
        },
        builder: (context, playerState) {
          debugPrint('Current UserState: ${playerState.runtimeType}');

          if (playerState is PlayerProfileLoading) {
            if (_cachedPlayer == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return buildPlayerProfile(context, _cachedPlayer!);
            }
          }
          if (playerState is PlayerProfileLoaded) {
            final player = playerState.user;
            return buildPlayerProfile(context, player);
          }
          if (playerState is PlayerProfileError) {
            return ErrorAndReloadWidget(
              errorTitle: 'Player profile not found',
              errorDetails: 'No profile found, try reloading the page.',
              labelText: 'Reload',
              buttonPressed: () {
                context.read<UserBloc>().add(FetchPlayerProfile());
              },
            );
          }
          return const Center(child: Text('Unexpected state'));
        },
      ),
    );
  }

  Widget buildPlayerProfile(BuildContext context, PlayerModel player) {
    return PullToRefresh(
      onRefresh: () async {
        context.read<UserBloc>().add(FetchPlayerProfile());
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: StaggeredColumn(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            staggerType: StaggerType.slide,
            slideAxis: SlideAxis.vertical,
            children: [
              SizedBox(height: 20.h),

              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.subTextcolor,
                child: ClipOval(
                  child:
                      player.profilePicture.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: player.profilePicture,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.appBGColor,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Image.asset(
                                  AppImageStrings.profileImage,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            AppImageStrings.profileImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                ),
              ),

              SizedBox(height: 10.h),
              _buildInfo('First name', player.firstName),
              _buildInfo('Last name', player.lastName),
              _buildInfo('Height(inches)', player.height.toString()),
              _buildInfo('Age', player.age.toString()),
              _buildInfo('Country', player.country),
              _buildInfo('Level', player.activeBundle),
              GestureDetector(
                onLongPress: () {
                  Clipboard.setData(
                    ClipboardData(text: player.performanceVideoLink),
                  );
                  AppToast.show(
                    context,
                    message: 'Link copied',
                    style: ToastStyle.success,
                  );
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => VideoWebViewPage(
                            url: player.performanceVideoLink,
                            title: 'Performance Video',
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Text(
                    textAlign: TextAlign.center,
                    '${AppTextStrings.performanceVideo}: ${player.performanceVideoLink}',
                    style: TextStyle(
                      color: AppColors.darkBackButton,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImageStrings.darkNextKickLogo),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        textAlign: TextAlign.center,
        '$label: ${value.capitalizeFirstLetter()}',
        style: TextStyle(
          color: AppColors.darkBackButton,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
