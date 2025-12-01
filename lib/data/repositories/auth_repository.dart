import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/dependency_injector/dependency_injector.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/login_response.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/data/models/team_model.dart';
import 'package:next_kick/data/notification_service.dart';

class AuthRepository {
  final AppApiClient _apiClient;
  final AppLocalStorageService _localStorage;

  AuthRepository({
    required AppApiClient apiClient,
    required AppLocalStorageService localStorage,
  }) : _apiClient = apiClient,
       _localStorage = localStorage;

  // TEAM SIGNUP

  Future<String> signUpTeam({
    required TeamModel team,
    required String password,
    required String confirmPassword,
    File? teamLogo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': team.email,
        'team_name': team.teamName,
        'user_type': team.userType,
        'password': password,
        'confirm_password': confirmPassword,
        'age_group': team.ageGroup,
        'location': team.location,
        if (teamLogo != null)
          'team_logo': await MultipartFile.fromFile(
            teamLogo.path,
            filename: teamLogo.path.split('/').last,
          ),
      });

      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'api/signup/',
        data: formData,
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Sign Up Successful');
        final data = response.data;
        final userType = data['user_type'] ?? team.userType;

        return userType;
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }

  // PLAYER SIGNUP

  Future<String> signUpPlayer({
    required PlayerModel player,
    required String password,
    required String confirmPassword,
    File? profilePicture,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': player.email,
        'first_name': player.firstName,
        'last_name': player.lastName,
        'user_type': player.userType,
        'password': password,
        'confirm_password': confirmPassword,
        'age': player.age,
        'player_position': player.playerPosition,
        'country': player.country,
        'height': player.height,
        if (profilePicture != null)
          'profile_picture': await MultipartFile.fromFile(
            profilePicture.path,
            filename: profilePicture.path.split('/').last,
          ),
      });

      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'api/signup/',
        data: formData,
        requiresAuth: false,
      );
      debugPrint('Uploading file: ${profilePicture?.path}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final playerData = data['user_type'] ?? player.userType;

        return playerData;
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }

  // LOGIN

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'api/login/',
        data: {'email': email, 'password': password},
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final userType = data['user']['user_type'];

        await _localStorage.saveTokens(
          accessToken: data['tokens']['access'],
          refreshToken: data['tokens']['refresh'],
        );
        await _localStorage.saveUserType(userType);

        dynamic user;

        if (userType == 'team') {
          final teamData = TeamModel.fromJson(data['team'] ?? data['user']);
          await _localStorage.saveTeamUser(teamData);
          debugPrint('user_type: $userType');
          user = teamData;
        } else {
          final playerData = PlayerModel.fromJson(
            data['player'] ?? data['user'],
          );
          await _localStorage.savePlayerUser(playerData);
          debugPrint('user_type: $userType');

          user = playerData;
        }

        final fcmToken = await FirebaseMessaging.instance.getToken();
        final deviceId = await getIt<NotificationService>().getDeviceId();

        if (fcmToken != null) {
          await _apiClient.updateFcmToken(
            fcmToken: fcmToken,
            deviceId: deviceId,
          );
          debugPrint('sending $fcmToken and $deviceId');
          await _localStorage.saveFcmToken(fcmToken);
        }
        return LoginResponse(userType: userType, user: user);
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }

  // FORGET PASSWORD

  Future<String> forgotPassword({required String email}) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'api/forget-password/',
        requiresAuth: false,
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final message = data['message'] ?? 'Password reset email sent.';
        return message;
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }
  // RESEND CODE

  Future<String> resendCode({required String email}) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'api/resend-code/',
        requiresAuth: false,
        data: {'email': email},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final message = data['message'] ?? 'Verification code resent.';
        return message;
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }

  // RESET PASSWORD

  Future<String> resetPassword({
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'api/reset-password/',
        requiresAuth: false,
        data: {
          'code': code,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final message = data['message'] ?? 'Password has been reset.';
        return message;
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }

  // LOGOUT

  Future<void> logout() async {
    try {
      await _apiClient.apiCall(type: RequestType.post, path: 'api/logout/');
    } catch (error) {
      debugPrint('logout error: $error');
    } finally {
      await _localStorage.logout();
    }
  }
}
