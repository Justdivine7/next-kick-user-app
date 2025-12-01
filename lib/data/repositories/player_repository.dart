import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';
import 'package:next_kick/data/models/player_model.dart';

class PlayerRepository {
  final AppApiClient _apiClient;
  final AppLocalStorageService _localStorage;

  PlayerRepository({
    required AppApiClient apiClient,
    required AppLocalStorageService localStorage,
  }) : _apiClient = apiClient,
       _localStorage = localStorage;

  Future<dynamic> fetchUserProfile() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: 'api/profile/',
        requiresAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final playerData = PlayerModel.fromJson(data);
        await _localStorage.savePlayerUser(playerData);

        return playerData;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<PlayerModel> updateUserProfile(
    PlayerModel player,
    File? profilePicture,
  ) async {
    try {
      final formData = FormData.fromMap({
        'email': player.email,
        'first_name': player.firstName,
        'last_name': player.lastName,
        'player_position':
            player.playerPosition.isNotEmpty
                ? player.playerPosition
                : _localStorage.getPlayerUser()?.playerPosition,
        'country': player.country,
        'height': player.height,
        'age': player.age,
        'performance_video_link': player.performanceVideoLink,

        if (profilePicture != null)
          'profile_picture': await MultipartFile.fromFile(
            profilePicture.path,
            filename: profilePicture.path.split('/').last,
          ),
      });
      final response = await _apiClient.apiCall(
        type: RequestType.patch,
        path: 'api/profile/',
        requiresAuth: true,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        // Add detailed logging
        debugPrint('📥 Raw Response Type: ${responseData.runtimeType}');
        debugPrint('📥 Raw Response: $responseData');

        if (responseData is Map<String, dynamic>) {
          final updatedUser = PlayerModel.fromJson(responseData);
          debugPrint('Updated User: $updatedUser');
          await _localStorage.savePlayerUser(updatedUser);
          return updatedUser;
        } else {
          throw Exception('Unexpected response format from server');
        }
      } else {
        throw Exception('Unexpected server response (${response.statusCode})');
      }
    } catch (error) {
      rethrow;
    }
  }
}
