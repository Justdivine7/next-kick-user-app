import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/widgets/exit_alert.dart';
import 'package:next_kick/common/widgets/pull_to_refresh.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/features/home/widgets/dashboard_cards.dart';
import 'package:next_kick/features/home/widgets/dashboard_user_details.dart';
import 'package:next_kick/common/widgets/next_kick_dark_background.dart';
import 'package:next_kick/features/user/bloc/user_bloc.dart';
import 'package:next_kick/features/user/bloc/user_event.dart';
import 'package:next_kick/features/user/bloc/user_state.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_list/player_dashboard_list_view.dart';

class PlayerDashboardView extends StatefulWidget {
  static const routeName = '/dashboard';
  const PlayerDashboardView({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerDashboardViewState();
}

class _PlayerDashboardViewState extends State<PlayerDashboardView> {
  final AppLocalStorageService _localStorage = getIt<AppLocalStorageService>();
  final ValueNotifier<PlayerModel?> _player = ValueNotifier<PlayerModel?>(null);

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
    // Fetch from backend immediately on load
    context.read<UserBloc>().add(FetchPlayerProfile());
  }

  Future<void> _loadPlayerData() async {
    final player = _localStorage.getPlayerUser();
    _player.value = player;
  }

  Future<void> _refreshData() async {
    context.read<UserBloc>().add(FetchPlayerProfile());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
        body: NextKickDarkBackground(
          child: SafeArea(
            child: BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is PlayerProfileLoaded) {
                  _player.value = state.user;
                }
              },
              child: PullToRefresh(
                onRefresh: _refreshData,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: 40.h,
                        child: Image.asset(
                          AppImageStrings.mainLightLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ValueListenableBuilder(
                      valueListenable: _player,
                      builder: (context, player, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child:
                              player == null
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : Column(
                                    key: ValueKey(player.playerId),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DashboardUserDetails(player: player),
                                      SizedBox(height: 6.h),
                                      DashboardCards(
                                        dashboardList: playerDashboardCards,
                                      ),
                                    ],
                                  ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
