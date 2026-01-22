import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/animated_pulsing_image.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/error_and_reload_widget.dart';
import 'package:next_kick/common/widgets/next_kick_dark_background.dart';
import 'package:next_kick/common/widgets/pull_to_refresh.dart';
import 'package:next_kick/common/widgets/staggered_column.dart';
import 'package:next_kick/features/team/dashboard/team_dashboard_view.dart';
import 'package:next_kick/features/team/tournament/bloc/tournament_bloc.dart';
import 'package:next_kick/features/team/tournament/widgets/tournament_name_and_location_registration_widget.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class TeamTournamentListView extends StatefulWidget {
  static const routeName = '/team-tournament-list';
  const TeamTournamentListView({super.key});

  @override
  State<TeamTournamentListView> createState() => _TeamTournamentListViewState();
}

class _TeamTournamentListViewState extends State<TeamTournamentListView> {
  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    context.read<TournamentBloc>().add(FetchTournaments(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      buildWhen: (previous, current) {
        return current is FetchTournamentError ||
            current is FetchTournamentLoaded ||
            current is FetchTournamentLoading;
      },
      builder: (context, tournamentState) {
        if (tournamentState is FetchTournamentLoading) {
          return Scaffold(
            backgroundColor: AppColors.darkBackgroundGradient,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: AppBackButton(
                onBackPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    TeamDashboardView.routeName,
                  );
                },
              ),
            ),
            body: Center(
              child: AnimatedPulsingImage(
                imagePath: AppImageStrings.manLogo,
              ),
            ),
          );
        }
        if (tournamentState is FetchTournamentError) {
          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: AppBackButton(
                onBackPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    TeamDashboardView.routeName,
                  );
                },
              ),
            ),
            body: ErrorAndReloadWidget(
              errorTitle: 'Unable to load tournaments',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => _loadTournaments(),
            ),
          );
        }
        if (tournamentState is FetchTournamentLoaded) {
          final tournaments = tournamentState.tournaments;
          if (tournaments.isEmpty) {
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
                  'No tournaments available',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.boldTextColor,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            extendBodyBehindAppBar: true,

            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: AppBackButton(
                onBackPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    TeamDashboardView.routeName,
                  );
                },
              ),
            ),
            body: NextKickDarkBackground(
              child: SafeArea(
                child: PullToRefresh(
                  onRefresh: () => _loadTournaments(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(height: 25),

                          Text(
                            AppTextStrings.tournaments,
                            style: context.textTheme.displayMedium?.copyWith(
                              color: AppColors.appBGColor,
                            ),
                          ),
                          SizedBox(height: 30),
                          StaggeredColumn(
                            staggerType: StaggerType.slide,
                            slideAxis: SlideAxis.vertical,
                            children: [
                              for (final tournament in tournaments) ...[
                                TournamentNameAndLocationRegistrationWidget(
                                  tournament: tournament,
                                ),
                                if (tournament != tournaments.last)
                                  SizedBox(height: 30),
                              ],
                            ],
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
            child: AnimatedPulsingImage(
              imagePath: AppImageStrings.nextKickDarkLogo,
            ),
          ),
        );
      },
    );
  }
}
