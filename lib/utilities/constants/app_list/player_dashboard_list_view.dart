import 'package:next_kick/features/player/drills/player_drill_view.dart';
import 'package:next_kick/features/player/profile/player_profile_view.dart';
import 'package:next_kick/features/player/settings/player_settings_view.dart';
import 'package:next_kick/features/player/tournaments/player_standings_view.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';

List<Map<String, dynamic>> playerDashboardCards = [
  {
    'title': AppTextStrings.drills,
    'big-image': AppImageStrings.playerOne,
    'small-image': AppImageStrings.drillCones,
    'action-text': AppTextStrings.trainHere,
    'route': PlayerDrillView.routeName,
  },
  {
    'title': AppTextStrings.standings,
    'big-image': AppImageStrings.nextKickTrophy,
    'small-image': '',
    'action-text': AppTextStrings.followTheAction,
    'route': PlayerStandingsView.routeName,
  },
  {
    'title': AppTextStrings.profile,
    'big-image': AppImageStrings.playerTwo,
    'small-image': AppImageStrings.profile,
    'action-text': AppTextStrings.viewProfile,
    'route': PlayerProfileView.routeName,
  },
  {
    'title': AppTextStrings.settings,
    'big-image': AppImageStrings.settingsCog,
    'small-image': AppImageStrings.settingsBig,
    'action-text': AppTextStrings.settings,
    'route': PlayerSettingsView.routeName,
  },
];
