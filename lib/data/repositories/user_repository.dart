import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/models/standing_model.dart';

class StandingRepository {
  final AppApiClient _apiClient;
  const StandingRepository(this._apiClient);

  Future<List<StandingModel>> fetchStandings() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: 'admin_app/standings/',
        requiresAuth: true,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as List;
        final standing =
            responseData.map((st) => StandingModel.fromJson(st)).toList();
        return standing;
      } else {
        throw Exception('Failed to fetch standings');
      }
    } catch (e) {
      rethrow;
    }
  }
}
