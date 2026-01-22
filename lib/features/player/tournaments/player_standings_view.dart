import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/animated_pulsing_image.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/web_socket/standings_web_socket_service.dart';
import 'package:next_kick/features/team/standings/bloc/standings_bloc.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PlayerStandingsView extends StatefulWidget {
  static const routeName = '/standings';
  const PlayerStandingsView({super.key});

  @override
  State<PlayerStandingsView> createState() => _PlayerStandingsViewState();
}

class _PlayerStandingsViewState extends State<PlayerStandingsView>
    with SingleTickerProviderStateMixin {
  late final StandingsWebSocketService _ws;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Don't start animation on init - only trigger on updates
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _ws = StandingsWebSocketService();
    final token = getIt<AppLocalStorageService>().getAccessToken();

    _ws.connect(token!, (standings) {
      debugPrint("🔥 WS update received: ${standings.length} items");

      if (mounted) {
        // Add event to bloc
        context.read<StandingsBloc>().add(StandingsUpdated(standings));

        // Trigger animation
        _animationController.forward(from: 0).then((_) {
          if (mounted) {
            _animationController.reverse();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StandingsBloc, StandingsState>(
      // Use BlocConsumer to listen to state changes
      listener: (context, state) {
        if (state is FetchStandingsSuccessful) {
          debugPrint(
            "✅ Bloc emitted new state with ${state.standings.length} standings",
          );
        }
      },
      builder: (context, standingState) {
        debugPrint("🔄 Building with state: ${standingState.runtimeType}");

        if (standingState is StandingsInitial) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: const AppBackButton(),
            ),
            body: Center(
              child: AnimatedPulsingImage(
                imagePath: AppImageStrings.nextKickDarkLogo,
              ),
            ),
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
              leading: const AppBackButton(),
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
                          return Transform.scale(
                            scale: 1.0 + (_animationController.value * 0.02),
                            child: Opacity(
                              opacity:
                                  0.7 + 0.3 * (1 - _animationController.value),
                              child: child,
                            ),
                          );
                        },
                        child:
                            standings.isEmpty
                                ? Column(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: AppColors.boldTextColor,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No standings available",
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: AppColors.boldTextColor,
                                          ),
                                    ),
                                  ],
                                )
                                : StaggeredColumn(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    staggerType: StaggerType.slide,
                                    slideAxis: SlideAxis.vertical,
                                    children: [
                                      for (int i = 0; i < standings.length; i++) ...[
                                        if (i > 0) const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                standings[i]
                                                    .teamName
                                                    .capitalizeFirstLetter(),
                                                style: context
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .boldTextColor,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              standings[i].points.toString(),
                                              style: context
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    color: AppColors
                                                        .boldTextColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
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
