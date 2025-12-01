import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/models/drill_model.dart';

class DrillRepository {
  final AppApiClient _client;
  DrillRepository(this._client);

  Future<List<DrillModel>> getPlayerDrills() async {
    try {
      final response = await _client.apiCall(
        type: RequestType.get,
        path: 'api/drills/',
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['drills'] as List;
        return data.map((drill) => DrillModel.fromJson(drill)).toList();
      } else {
        throw Exception('Failed to load drills');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> submitDrill({
    required String drillId,
    required String link,
  }) async {
    try {
      final response = await _client.apiCall(
        type: RequestType.put,
        path: 'api/submit-drill/$drillId/',
        requiresAuth: true,
        data: {'submission_link': link},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final message = data['message'] ?? 'Drill submitted successfully.';
        return message;
      } else {
        throw Exception(response.data['detail'] ?? 'Failed to submit drill');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> completeLevel(String message) async {
    try {
      final response = await _client.apiCall(
        type: RequestType.post,
        path: 'api/complete-level/',
        requiresAuth: true,
        data: {'message': message},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final msg = data['message'] ?? 'Level completed successfully.';
        return msg;
      } else {
        throw Exception('Failed to complete level');
      }
    } catch (error) {
      rethrow;
    }
  }
}
