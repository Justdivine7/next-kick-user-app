import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/common/widgets/shimmer_loading_overlay.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/web_socket/standings_web_socket_service.dart';
import 'package:next_kick/features/team/standings/bloc/standings_bloc.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/enums/shimmer_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class TeamStandingsView extends StatefulWidget {
  static const routeName = '/team_stadings';
  const TeamStandingsView({super.key});

  @override
  State<TeamStandingsView> createState() => _TeamStandingsViewState();
}

class _TeamStandingsViewState extends State<TeamStandingsView>
    with SingleTickerProviderStateMixin {
  late final StandingsWebSocketService _ws;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _ws = StandingsWebSocketService();
    final token = getIt<AppLocalStorageService>().getAccessToken();

    _ws.connect(token!, (standings) {
      context.read<StandingsBloc>().add(StandingsUpdated(standings));
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StandingsBloc, StandingsState>(
      builder: (context, standingState) {
        if (standingState is StandingsInitial) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: AppBackButton(),
            ),
            body: ShimmerLoadingOverlay(pageType: ShimmerEnum.notification),
          );
        }

        if (standingState is FetchStandingsSuccessful) {
          final standings = standingState.standings;

          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              forceMaterialTransparency: true,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: AppBackButton(),
            ),
            body: NextKickLightBackground(
              image: AppImageStrings.lightSphere,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Team",
                            style: context.textTheme.displayMedium?.copyWith(
                              color: AppColors.boldTextColor,
                            ),
                          ),
                          Text(
                            "Points",
                            style: context.textTheme.displayMedium?.copyWith(
                              color: AppColors.boldTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Live animation on update
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.5 + 0.5 * _animationController.value,
                            child: child,
                          );
                        },
                        child:
                            standings.isEmpty
                                ? Column(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: AppColors.whiteColor.withOpacity(
                                        0.6,
                                      ),
                                      size: 64,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "No standings available",
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: AppColors.boldTextColor,
                                          ),
                                    ),
                                  ],
                                )
                                : ListView.separated(
                                  separatorBuilder:
                                      (_, __) => SizedBox(height: 16),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: standings.length,
                                  itemBuilder: (context, index) {
                                    final standing = standings[index];
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            standing.teamName
                                                .capitalizeFirstLetter(),
                                            style: context.textTheme.titleLarge
                                                ?.copyWith(
                                                  color:
                                                      AppColors.boldTextColor,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          standing.points.toString(),
                                          style: context.textTheme.titleLarge
                                              ?.copyWith(
                                                color: AppColors.boldTextColor,
                                              ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _ws.disconnect();
    _animationController.dispose();
    super.dispose();
  }
}
