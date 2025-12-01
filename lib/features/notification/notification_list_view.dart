import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/error_and_reload_widget.dart';
import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/common/widgets/pull_to_refresh.dart';
import 'package:next_kick/common/widgets/shimmer_loading_overlay.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/features/notification/bloc/notification_bloc.dart';
import 'package:next_kick/features/notification/widget/notification_card.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/enums/shimmer_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class NotificationListView extends StatefulWidget {
  final String? notificationId;
  static const routeName = '/notifications';

  const NotificationListView({super.key, this.notificationId});

  @override
  State<StatefulWidget> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  final AppLocalStorageService _localStorage = getIt<AppLocalStorageService>();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
   }

   

  Future<void> _loadNotifications() async {
    final userType = _localStorage.getSavedUserType();
    if (userType == null) {
      debugPrint('User type not found!');
      return;
    }
    if (!mounted) return;
    context.read<NotificationBloc>().add(LoadNotifications(userType, true));
  }

  Future<void> _handleRefresh() async {
    final userType = _localStorage.getSavedUserType();
    if (userType == null) {
      debugPrint('User type not found!');
      return;
    }
    context.read<NotificationBloc>().add(LoadNotifications(userType, true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, notificationState) {
        if (notificationState is NotificationLoading) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: const AppBackButton(),
            ),
            body: ShimmerLoadingOverlay(pageType: ShimmerEnum.notification),
          );
        }
        if (notificationState is NotificationError) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: const AppBackButton(),
            ),
            body: ErrorAndReloadWidget(
              errorTitle: 'Unable to load notifications',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => _loadNotifications(),
            ),
          );
        }
        if (notificationState is NotificationEmpty) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: const AppBackButton(),
            ),
            body: Center(
              child: Text(
                'No notifications available',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.boldTextColor,
                ),
              ),
            ),
          );
        }
        if (notificationState is NotificationLoaded) {
          final notifications = notificationState.notifications;

          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: AppBackButton(),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    AppImageStrings.nextKickbell,
                    width: 30.w,
                    height: 30.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            body: PullToRefresh(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: NextKickLightBackground(
                    image: AppImageStrings.lightSphere,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationCard(notification: notification);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.lightBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            toolbarHeight: 40,
            leading: const AppBackButton(),
          ),
          body: ShimmerLoadingOverlay(pageType: ShimmerEnum.notification),
        );
      },
    );
  }
}
