import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/models/fixture_model.dart';
import 'package:next_kick/data/repositories/team_repository.dart';

part 'fixtures_event.dart';
part 'fixtures_state.dart';

class FixturesBloc extends Bloc<FixturesEvent, FixturesState> {
  final TeamRepository _teamRepository;

  FixturesBloc(this._teamRepository) : super(FixturesInitial()) {
    on<FetchFixtures>(_onFetchFixtures);
  }
  Future<void> _onFetchFixtures(
    FetchFixtures event,
    Emitter<FixturesState> emit,
  ) async {
    emit(FetchFixturesLoading());
    try {
      final fixtures = await _teamRepository.fetchAllFixtures();
      emit(FetchFixturesLoaded(fixture: fixtures));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchFixturesError(errorMessage: errorMessage));
    }
  }
}
