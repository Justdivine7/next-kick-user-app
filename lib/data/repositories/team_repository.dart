import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/models/fixture_model.dart';
import 'package:next_kick/data/models/tournament_model.dart';

class TeamRepository {
  final AppApiClient _apiClient;
  const TeamRepository(this._apiClient);

  Future<List<FixtureModel>> fetchAllFixtures() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: 'admin_app/team/fixtures/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final fixturesList = response.data['fixtures'] as List;
        return fixturesList
            .map((fixture) => FixtureModel.fromJson(fixture))
            .toList();
      } else {
        throw Exception("Couldn't fetch fixtures");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<TournamentModel>> fetchAllTournaments() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: 'admin_app/tournaments/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final tournaments = response.data['results'] as List;

        return tournaments.map((t) => TournamentModel.fromJson(t)).toList();
      } else {
        throw Exception('Failed to fetch tournaments');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> registerForTournament({required String tournamentId}) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'admin_app/tournaments/$tournamentId/register/',
        requiresAuth: true,
        data: {'terms_accepted': true},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['payment_url'];
      } else {
        throw Exception("Couldn't register for tournament");
      }
    } catch (error) {
      rethrow;
    }
  }
}
