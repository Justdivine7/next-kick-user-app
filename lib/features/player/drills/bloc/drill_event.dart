part of 'drill_bloc.dart';

sealed class DrillEvent extends Equatable {
  const DrillEvent();

  @override
  List<Object> get props => [];
}

class FetchPlayerDrills extends DrillEvent {}

class SubmitDrill extends DrillEvent {
  final String drillId;
  final String submissionLink;

  const SubmitDrill({required this.drillId, required this.submissionLink});

  @override
  List<Object> get props => [drillId, submissionLink];
}

class CompleteLevel extends DrillEvent {
  const CompleteLevel();

  @override
  List<Object> get props => [];
}
