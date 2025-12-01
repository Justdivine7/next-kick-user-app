part of 'fixtures_bloc.dart';

sealed class FixturesEvent extends Equatable {
  const FixturesEvent();

  @override
  List<Object?> get props => [];
}

class FetchFixtures extends FixturesEvent {
  final bool forceRefresh;
  const FetchFixtures({required this.forceRefresh});
  @override
  List<Object?> get props => [forceRefresh];
}
