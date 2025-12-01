part of 'drill_bloc.dart';

sealed class DrillState extends Equatable {
  const DrillState();

  @override
  List<Object> get props => [];
}

final class DrillInitial extends DrillState {}

class DrillLoading extends DrillState {}

final class DrillLoaded extends DrillState {
  final List<DrillModel> drills;

  const DrillLoaded({required this.drills});

  @override
  List<Object> get props => [drills];
}

final class DrillError extends DrillState {
  final String message;

  const DrillError({required this.message});

  @override
  List<Object> get props => [message];
}

class DrillSubmittedLoading extends DrillState {}

final class DrillSubmitted extends DrillState {
  final String message;

  const DrillSubmitted({required this.message});

  @override
  List<Object> get props => [message];
}

final class DrillSubmissionError extends DrillState {
  final String message;
  final List<DrillModel> drills; // Add drills list

  const DrillSubmissionError({
    required this.message,
    required this.drills, // Add to constructor
  });

  @override
  List<Object> get props => [message, drills]; // Add to props
}

class LevelCompletionLoading extends DrillState {}

final class LevelCompleted extends DrillState {
  final String message;

  const LevelCompleted({required this.message});

  @override
  List<Object> get props => [message];
}

final class LevelCompletionError extends DrillState {
  final String message;

  const LevelCompletionError({required this.message});

  @override
  List<Object> get props => [message];
}
