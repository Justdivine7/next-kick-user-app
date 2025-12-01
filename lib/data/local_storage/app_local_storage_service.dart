import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/data/models/team_model.dart';

class AppLocalStorageService {
  final GetStorage _localBox;

  static const String _teamDataKey = 'team_data';
  static const String _playerDataKey = 'player_data';
  static const String _userTypeKey = 'user_type';
  static const String _fcmTokenKey = 'fcm_token';

  AppLocalStorageService(this._localBox);

  bool get hasSeenIntro {
    return _localBox.read('has_seen_intro') == true;
  }

  void setIntroAsSeen() {
    _localBox.write('has_seen_intro', true);
    debugPrint('✅ Set hasSeenIntro to true');
  }

  bool get hasAccount {
    return _localBox.read('has_account') == true;
  }

  void setHasAccount() {
    _localBox.write('has_account', true);
    debugPrint('✅ Set hasAccount to true');
  }

  // Save user tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _localBox.write('access_token', accessToken);
    await _localBox.write('refresh_token', refreshToken);
  }

  Future<void> saveFcmToken(String token) async {
    await _localBox.write(_fcmTokenKey, token);
  }

  Future<String?> getFcmToken() async {
    return _localBox.read(_fcmTokenKey);
  }

  // save user type
  Future<void> saveUserType(String userType) async {
    await _localBox.write('user_type', userType);
  }

  String? getSavedUserType() {
    final userType = _localBox.read('user_type');
    if (userType == null) return null;
    return userType;
  }

  // Save user data
  Future<void> saveTeamUser(TeamModel team) async {
    await _localBox.write(_teamDataKey, team.toJson());
    await _localBox.write('user_type', 'team');
    await _localBox.write('is_logged_in', true);
    await _localBox.remove(_playerDataKey);
    setHasAccount();
    setIntroAsSeen();
  }

  Future<void> savePlayerUser(PlayerModel user) async {
    await _localBox.write(_playerDataKey, user.toJson());
    await _localBox.write('user_type', 'player');
    await _localBox.write('is_logged_in', true);
    await _localBox.remove(_teamDataKey);
    setHasAccount();
    setIntroAsSeen();
  }

  // Get user data
  TeamModel? getTeamUser() {
    final userData = _localBox.read(_teamDataKey);
    if (userData == null) return null;
    try {
      return TeamModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  PlayerModel? getPlayerUser() {
    final userData = _localBox.read(_playerDataKey);
    if (userData == null) return null;

    try {
      return PlayerModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  dynamic get currentUser {
    return getTeamUser() ?? getPlayerUser();
  }

  // Get current user type
  String? get userType => _localBox.read(_userTypeKey);
  bool get isTeamUser => userType == 'team';
  bool get isPlayerUser => userType == 'player';

  // Get user tokens
  String? getAccessToken() => _localBox.read('access_token');
  String? getRefreshToken() => _localBox.read('refresh_token');

  // Clear user data except intro seen and has account
  Future<void> clearTeamUser() async {
    debugPrint('🧹 Starting clearTeamUser...');
    await _localBox.remove(_teamDataKey);
    await _localBox.remove('access_token');
    await _localBox.remove('refresh_token');
    await _localBox.remove('is_logged_in');
    await _localBox.remove('user_type');

    // Ensure user goes to login, not signup
    await _localBox.write('has_account', true);
    await _localBox.write('has_seen_intro', true);

    // Verify the writes
    final hasAcc = _localBox.read('has_account');
    final hasIntro = _localBox.read('has_seen_intro');
    debugPrint(
      '✅ clearTeamUser complete. has_account=$hasAcc, has_seen_intro=$hasIntro',
    );
  }

  Future<void> clearPlayerUser() async {
    debugPrint('🧹 Starting clearPlayerUser...');
    await _localBox.remove(_playerDataKey);
    await _localBox.remove('access_token');
    await _localBox.remove('refresh_token');
    await _localBox.remove('is_logged_in');
    await _localBox.remove('user_type');

    // Ensure user goes to login, not signup
    await _localBox.write('has_account', true);
    await _localBox.write('has_seen_intro', true);

    // Verify the writes
    final hasAcc = _localBox.read('has_account');
    final hasIntro = _localBox.read('has_seen_intro');
    debugPrint(
      '✅ clearPlayerUser complete. has_account=$hasAcc, has_seen_intro=$hasIntro',
    );
  }

  // Logout current user (preserve intro seen and has account)
  Future<void> logout() async {
    debugPrint('🚪 Starting logout...');

    // Clear user-related data
    await _localBox.remove(_teamDataKey);
    await _localBox.remove(_playerDataKey);
    await _localBox.remove('access_token');
    await _localBox.remove('refresh_token');
    await _localBox.remove('is_logged_in');
    await _localBox.remove('user_type');

    // CRITICAL: Ensure has_account is set to true so user goes to login screen
    await _localBox.write('has_account', true);
    await _localBox.write('has_seen_intro', true);

    // Verify the writes
    final hasAcc = _localBox.read('has_account');
    final hasIntro = _localBox.read('has_seen_intro');
    debugPrint(
      '✅ Logout complete. has_account=$hasAcc, has_seen_intro=$hasIntro',
    );
  }

  // Complete logout (clear all data)
  Future<void> completeLogout() async {
    debugPrint('🧨 Complete logout - erasing all storage');
    await _localBox.erase();
  }

  // Determine if intro should be skipped
  bool get shouldSkipIntro => hasAccount || hasSeenIntro;

  // Determine if user is logged in
  bool get isLoggedIn => _localBox.read('is_logged_in') ?? false;
}
