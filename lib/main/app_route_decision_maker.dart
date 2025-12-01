import 'package:flutter/material.dart';
import 'package:next_kick/common/widgets/app_loading_overlay.dart';
import 'package:next_kick/common/widgets/app_toast/app_toast.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/features/auth/views/player_or_team_signup_view.dart';
import 'package:next_kick/features/auth/views/login_view.dart';
import 'package:next_kick/features/player/dashboard/player_dashboard_view.dart';
import 'package:next_kick/features/team/dashboard/team_dashboard_view.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';

class AppRouteDecisionMaker extends StatefulWidget {
  static const routeName = 'route-maker';
  const AppRouteDecisionMaker({super.key});

  @override
  State<AppRouteDecisionMaker> createState() => _AppRouteDecisionMakerState();
}

class _AppRouteDecisionMakerState extends State<AppRouteDecisionMaker> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAppState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: AppLoadingOverlay());
        }

        if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppToast.show(
              context,
              message: snapshot.error.toString(),
              style: ToastStyle.error,
            );
          });
          // On error, default to signup for new users
          return const PlayerOrTeamSignupView();
        }

        final data = snapshot.data;
        if (data == null) {
          return const PlayerOrTeamSignupView();
        }

        final bool hasSeenIntro = data['hasSeenIntro'] ?? false;
        final bool hasAccount = data['hasAccount'] ?? false;
        final bool isLoggedIn = data['isLoggedIn'] ?? false;
        final String? userType = data['userType'];

        // Debug logging
        debugPrint('=== ROUTE DECISION (Build #${DateTime.now().millisecondsSinceEpoch}) ===');
        debugPrint('hasSeenIntro: $hasSeenIntro');
        debugPrint('hasAccount: $hasAccount');
        debugPrint('isLoggedIn: $isLoggedIn');
        debugPrint('userType: $userType');

        // ---------- 1. Logged in users go to dashboard ----------
        if (isLoggedIn && userType != null) {
          debugPrint('Route: Dashboard ($userType)');
          switch (userType) {
            case 'team':
              return const TeamDashboardView();
            case 'player':
              return const PlayerDashboardView();
            default:
              debugPrint('Invalid userType, redirecting to Login');
              return const LoginView();
          }
        }

        // ---------- 2. Has account or seen intro → Login ----------
        if (hasAccount || hasSeenIntro) {
          debugPrint(
            'Route: Login (has_account=$hasAccount, seen_intro=$hasSeenIntro)',
          );
          return const LoginView();
        }

        // ---------- 3. Brand new user → Signup ----------
        debugPrint('Route: Signup (brand new user)');
        return const PlayerOrTeamSignupView();
      },
    );
  }

  Future<Map<String, dynamic>> _getAppState() async {
    final localStorage = getIt<AppLocalStorageService>();

    final hasSeenIntro = localStorage.hasSeenIntro;
    final hasAccount = localStorage.hasAccount;
    final isLoggedIn = localStorage.isLoggedIn;
    final userType = localStorage.userType;

    debugPrint('=== STORAGE VALUES (Read #${DateTime.now().millisecondsSinceEpoch}) ===');
    debugPrint('hasSeenIntro: $hasSeenIntro');
    debugPrint('hasAccount: $hasAccount');
    debugPrint('isLoggedIn: $isLoggedIn');
    debugPrint('userType: $userType');

    return {
      'hasSeenIntro': hasSeenIntro,
      'hasAccount': hasAccount,
      'isLoggedIn': isLoggedIn,
      'userType': userType,
    };
  }
}