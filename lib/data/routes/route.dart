import 'package:flutter/material.dart';
import 'package:next_kick/data/models/tournament_model.dart';
import 'package:next_kick/data/models/upload_picture_args.dart';
import 'package:next_kick/features/team/tournament/view/payment_cancelled_view.dart';
import 'package:next_kick/features/team/tournament/view/payment_success_view.dart';
import 'package:next_kick/main/app_route_decision_maker.dart';
import 'package:next_kick/main/app_splash_screen.dart';
import 'package:next_kick/features/auth/views/player_or_team_signup_view.dart';
import 'package:next_kick/features/auth/views/team_signup_view.dart';
import 'package:next_kick/features/team/dashboard/team_dashboard_view.dart';
import 'package:next_kick/features/team/fixtures_and_standings/team_fixtures_list_view.dart';
import 'package:next_kick/features/team/tournament/view/team_pay_amount.dart';
import 'package:next_kick/features/team/settings/team_settings_view.dart';
import 'package:next_kick/features/team/standings/view/team_standings_view.dart';
import 'package:next_kick/features/team/tournament/view/team_tournament_list_view.dart';
import 'package:next_kick/features/team/tournament/view/team_tournament_terms_and_condition.dart';
import 'package:next_kick/utilities/helpers/ui_helpers.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/features/auth/views/reset_password_view.dart';
import 'package:next_kick/features/auth/views/send_email_for_otp_view.dart';
import 'package:next_kick/features/auth/views/player_sign_up_view.dart';
import 'package:next_kick/features/auth/views/upload_picture_view.dart';
import 'package:next_kick/features/player/player_view/player_congratulations_view.dart';
import 'package:next_kick/features/player/dashboard/player_dashboard_view.dart';
import 'package:next_kick/features/player/drills/player_drill_view.dart';
import 'package:next_kick/features/player/tournaments/player_fixtures_view.dart';
import 'package:next_kick/features/notification/notification_list_view.dart';
import 'package:next_kick/features/player/profile/player_profile_edit_view.dart';
import 'package:next_kick/features/player/profile/player_profile_view.dart';
import 'package:next_kick/features/player/settings/player_settings_view.dart';
import 'package:next_kick/features/player/tournaments/player_standings_view.dart';
import 'package:next_kick/features/player/tournaments/player_tournament_view.dart';
import 'package:next_kick/common/widgets/error_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppSplashScreen.routeName:
      return createFadeTransition(const AppSplashScreen());
    case AppRouteDecisionMaker.routeName:
      return createFadeTransition(const AppRouteDecisionMaker());
    case PlayerOrTeamSignupView.routeName:
      return createFadeTransition(const PlayerOrTeamSignupView());
    case TeamSignupView.routeName:
      return createFadeTransition(const TeamSignupView());
    case LoginView.routeName:
      return createFadeTransition(LoginView());
    case PlayerSignUpView.routeName:
      return createFadeTransition(PlayerSignUpView());
    case ResetPasswordView.routeName:
      final args = settings.arguments;
      if (args is String) {
        return createFadeTransition(ResetPasswordView(email: args));
      }
      // Defensive fallback in case something goes wrong
      return createFadeTransition(const ErrorView());
    case UploadPictureView.routeName:
      final args = settings.arguments as UploadPictureArgs;
      return createFadeTransition(
        UploadPictureView(
          player: args.player,
          password: args.password,
          confirmPassword: args.confirmPassword,
        ),
      );
    case SendEmailForOtpView.routeName:
      return createFadeTransition(SendEmailForOtpView());
    case PlayerDashboardView.routeName:
      return createFadeTransition(PlayerDashboardView());
    case PlayerCongratulationsView.routeName:
      return createFadeTransition(PlayerCongratulationsView());
    case PlayerProfileView.routeName:
      return createFadeTransition(PlayerProfileView());
    case PlayerSettingsView.routeName:
      return createFadeTransition(PlayerSettingsView());
    case NotificationListView.routeName:
      final notificationId = settings.arguments as String?;
      return createFadeTransition(
        NotificationListView(notificationId: notificationId),
      );
    case PlayerProfileEditView.routeName:
      return createFadeTransition(PlayerProfileEditView());

    case PlayerDrillView.routeName:
      return createFadeTransition(PlayerDrillView());
    case PlayerTournamentView.routeName:
      return createFadeTransition(PlayerTournamentView());
    case PlayerFixturesView.routeName:
      return createFadeTransition(PlayerFixturesView());
    case PlayerStandingsView.routeName:
      return createFadeTransition(PlayerStandingsView());
    case TeamDashboardView.routeName:
      return createFadeTransition(const TeamDashboardView());
    case TeamTournamentListView.routeName:
      return createFadeTransition(const TeamTournamentListView());
    case PaymentSuccessView.routeName:
      return createFadeTransition(const PaymentSuccessView());
    case PaymentCancelledView.routeName:
      return createFadeTransition(const PaymentCancelledView());
    case TeamSettingsView.routeName:
      return createFadeTransition(const TeamSettingsView());

    case TeamTournamentTermsAndCondition.routeName:
      final tournament = settings.arguments as TournamentModel;
      return createFadeTransition(
        TeamTournamentTermsAndCondition(tournament: tournament),
      );
    case TeamPayAmount.routeName:
      final url = settings.arguments as String;
      return createFadeTransition(TeamPayAmount(url: url));
    case TeamStandingsView.routeName:
      return createFadeTransition(TeamStandingsView());
    case TeamFixturesListView.routeName:
      return createFadeTransition(TeamFixturesListView());
    default:
      return MaterialPageRoute(builder: (context) => ErrorView());
  }
}
