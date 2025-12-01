part of 'fixtures_bloc.dart';

sealed class FixturesState extends Equatable {
  const FixturesState();

  @override
  List<Object?> get props => [];
}

final class FixturesInitial extends FixturesState {}

final class FetchFixturesLoading extends FixturesState {}

final class FetchFixturesLoaded extends FixturesState {
  final List<FixtureModel> fixture;
  const FetchFixturesLoaded({required this.fixture});
  @override
  List<Object?> get props => [fixture];
}

final class FetchFixturesError extends FixturesState {
  final String errorMessage;
  const FetchFixturesError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
