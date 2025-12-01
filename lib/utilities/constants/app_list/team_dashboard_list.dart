import 'package:next_kick/features/team/fixtures_and_standings/team_fixtures_list_view.dart';
import 'package:next_kick/features/team/settings/team_settings_view.dart';
import 'package:next_kick/features/team/standings/view/team_standings_view.dart';
import 'package:next_kick/features/team/tournament/view/team_tournament_list_view.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';

List<Map<String, dynamic>> teamDashboardCards = [
  {
    'title': AppTextStrings.enterTournament,
    'big-image': AppImageStrings.tournamentCardImage,
    'small-image': '',
    'action-text': '',
    'route': TeamTournamentListView.routeName,
  },
  {
    'title': AppTextStrings.fixtures,
    'big-image': AppImageStrings.nextKickTrophy,
    'small-image': '',
    'action-text': '',
    'route': TeamFixturesListView.routeName,
  },
  {
    'title': AppTextStrings.standings,
    'big-image': AppImageStrings.standing,
    'small-image': '',
    'action-text': '',
    'route': TeamStandingsView.routeName,
  },
  {
    'title': AppTextStrings.settings,
    'big-image': AppImageStrings.settingsCog,
    'small-image': '',
    'action-text': '',
    'route': TeamSettingsView.routeName,
  },
];
