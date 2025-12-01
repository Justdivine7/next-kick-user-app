part of 'standings_bloc.dart';

sealed class StandingsState extends Equatable {
  const StandingsState();
  
  @override
  List<Object?> get props => [];
}

final class StandingsInitial extends StandingsState {}

final class FetchStandingsSuccessful extends StandingsState {
  final List<StandingModel> standings;
  final int updateCount; // Simple counter to force updates
  
  const FetchStandingsSuccessful(this.standings, {this.updateCount = 0});
  
  @override
  List<Object?> get props => [standings, updateCount];
}