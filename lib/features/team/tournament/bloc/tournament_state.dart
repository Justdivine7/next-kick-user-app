part of 'tournament_bloc.dart';

sealed class TournamentState extends Equatable {
  const TournamentState();

  @override
  List<Object?> get props => [];
}

final class TournamentInitial extends TournamentState {}

final class FetchTournamentLoading extends TournamentState {}

final class FetchTournamentLoaded extends TournamentState {
  final List<TournamentModel> tournaments;
  const FetchTournamentLoaded({required this.tournaments});
  @override
  List<Object?> get props => [tournaments];
}

final class FetchTournamentError extends TournamentState {
  final String errorMessage;
  const FetchTournamentError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

final class RegisterForTournamentLoading extends TournamentState {}

final class RegisterForTournamentSuccessful extends TournamentState {
  final String message;
  const RegisterForTournamentSuccessful({required this.message});
  @override
  List<Object?> get props => [message];
}

final class RegisterForTournamentError extends TournamentState {
  final String errorMessage;
  const RegisterForTournamentError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}


