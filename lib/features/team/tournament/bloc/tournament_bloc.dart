import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/models/tournament_model.dart';
import 'package:next_kick/data/repositories/team_repository.dart';

part 'tournament_event.dart';
part 'tournament_state.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final TeamRepository _teamRepository;
  TournamentBloc(this._teamRepository) : super(TournamentInitial()) {
    on<FetchTournaments>(_onFetchTournaments);
    on<RegisterForTournaments>(_onRegisterForTournaments);
  }

  Future<void> _onFetchTournaments(
    FetchTournaments event,
    Emitter<TournamentState> emit,
  ) async {
    emit(FetchTournamentLoading());
    try {
      final tournaments = await _teamRepository.fetchAllTournaments();
      emit(FetchTournamentLoaded(tournaments: tournaments));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(FetchTournamentError(errorMessage: errorMessage));
    }
  }

  Future<void> _onRegisterForTournaments(
    RegisterForTournaments event,
    Emitter<TournamentState> emit,
  ) async {
    emit(RegisterForTournamentLoading());
    try {
      final message = await _teamRepository.registerForTournament(
        tournamentId: event.tournamentId,
      );
      emit(RegisterForTournamentSuccessful(message: message));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(RegisterForTournamentError(errorMessage: errorMessage));
    }
  }
}
