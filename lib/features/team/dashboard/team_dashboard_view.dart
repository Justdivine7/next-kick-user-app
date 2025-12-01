import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/exit_alert.dart';
import 'package:next_kick/common/widgets/next_kick_dark_background.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/team_model.dart';
import 'package:next_kick/features/home/widgets/dashboard_cards.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_list/team_dashboard_list.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class TeamDashboardView extends StatefulWidget {
  static const routeName = '/team-dashboard';
  const TeamDashboardView({super.key});

  @override
  State<TeamDashboardView> createState() => _TeamDashboardViewState();
}

class _TeamDashboardViewState extends State<TeamDashboardView> {
  final AppLocalStorageService _localStorage = getIt<AppLocalStorageService>();
  final ValueNotifier<TeamModel?> _team = ValueNotifier<TeamModel?>(null);

  @override
  void initState() {
    super.initState();
    _loadTeamData();
  }

  Future<void> _loadTeamData() async {
    final team = _localStorage.getTeamUser();
    _team.value = team;
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
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 30.h),

                  SizedBox(
                    height: 40.h,
                    child: Image.asset(
                      AppImageStrings.mainLightLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    '${AppTextStrings.hello} ${_team.value?.teamName.capitalizeFirstLetter()}',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${AppTextStrings.location}: ${_team.value?.location.capitalizeFirstLetter()}',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  DashboardCards(dashboardList: teamDashboardCards),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
