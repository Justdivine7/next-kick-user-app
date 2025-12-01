import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_back_button.dart';
import 'package:next_kick/common/widgets/error_and_reload_widget.dart';
import 'package:next_kick/common/widgets/next_kick_light_background.dart';
import 'package:next_kick/common/widgets/pull_to_refresh.dart';
import 'package:next_kick/common/widgets/shimmer_loading_overlay.dart';
import 'package:next_kick/features/team/fixtures_and_standings/bloc/fixtures_bloc.dart';
import 'package:next_kick/features/team/fixtures_and_standings/widget/fixture_card.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/enums/shimmer_enum.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PlayerFixturesView extends StatefulWidget {
  static const routeName = '/fixtures';
  const PlayerFixturesView({super.key});

  @override
  State<PlayerFixturesView> createState() => _PlayerFixturesViewState();
}

class _PlayerFixturesViewState extends State<PlayerFixturesView> {
  @override
  void initState() {
    super.initState();
    _loadFixtures();
  }

  Future<void> _loadFixtures() async {
    context.read<FixturesBloc>().add(FetchFixtures(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixturesBloc, FixturesState>(
      builder: (context, fixtureState) {
        if (fixtureState is FetchFixturesLoading) {
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
        if (fixtureState is FetchFixturesError) {
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
              errorTitle: 'Unable to load fixtures',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => _loadFixtures(),
            ),
          );
        }
        if (fixtureState is FetchFixturesLoaded) {
          final fixtures = fixtureState.fixture;
          if (fixtures.isEmpty) {
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
                  'No fixture available',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.boldTextColor,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,

            appBar: AppBar(
              backgroundColor: AppColors.lightBackgroundColor,
              // forceMaterialTransparency: true,
              elevation: 0,
              leadingWidth: 80.w,
              toolbarHeight: 40.h,
              leading: AppBackButton(),
            ),
            body: NextKickLightBackground(
              image: AppImageStrings.lightSphere,
              alignment: Alignment.center,
              child: PullToRefresh(
                onRefresh: _loadFixtures,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: fixtures.length,
                        itemBuilder: (context, index) {
                          final f = fixtures[index];
                          return FixtureCard(
                            teamA: f.teamOneName,
                            teamB: f.teamTwoName,
                            date: f.matchDate,
                            time: f.matchTime,
                            venue: f.venue,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: 200.w,
              height: 80.h,
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImageStrings.darkLogo),
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
