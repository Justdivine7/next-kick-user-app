part of 'tournament_bloc.dart';

sealed class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object?> get props => [];
}

class FetchTournaments extends TournamentEvent {
  final bool forceRefresh;
  const FetchTournaments({required this.forceRefresh});
  @override
  List<Object?> get props => [forceRefresh];
}

class RegisterForTournaments extends TournamentEvent {
  final String tournamentId;

  const RegisterForTournaments({required this.tournamentId});

  @override
  List<Object?> get props => [tournamentId];
}
