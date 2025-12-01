part of 'standings_bloc.dart';

sealed class StandingsEvent extends Equatable {
  const StandingsEvent();
  @override
  List<Object?> get props => [];
}

class StandingsUpdated extends StandingsEvent {
  final List<StandingModel> standings;
  const StandingsUpdated(this.standings);

  @override
  List<Object?> get props => [standings];
}
