import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/models/drill_model.dart';
import 'package:next_kick/data/repositories/drill_repository.dart';

part 'drill_event.dart';
part 'drill_state.dart';

class DrillBloc extends Bloc<DrillEvent, DrillState> {
  final List<DrillModel> cachedDrills = [];
  final DrillRepository _repository;
  DrillBloc(this._repository) : super(DrillInitial()) {
    on<FetchPlayerDrills>(_onFetchPlayerDrills);
    on<SubmitDrill>(_onSubmitDrill);
    on<CompleteLevel>(_onCompleteLevel);
  }

  Future<void> _onFetchPlayerDrills(
    FetchPlayerDrills event,
    Emitter<DrillState> emit,
  ) async {
    emit(DrillLoading());
    try {
      final drills = await _repository.getPlayerDrills();
      cachedDrills
        ..clear()
        ..addAll(List.from(drills));
      emit(DrillLoaded(drills: List<DrillModel>.from(cachedDrills)));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(DrillError(message: errorMessage));
    }
  }

  Future<void> _onSubmitDrill(
    SubmitDrill event,
    Emitter<DrillState> emit,
  ) async {
    emit(DrillSubmittedLoading());
    try {
      final message = await _repository.submitDrill(
        drillId: event.drillId,
        link: event.submissionLink,
      );
      emit(DrillSubmitted(message: message));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(
        DrillSubmissionError(
          message: errorMessage,
          drills: List<DrillModel>.from(cachedDrills), // Pass cached drills
        ),
      );
    }
  }

  Future<void> _onCompleteLevel(
    CompleteLevel event,
    Emitter<DrillState> emit,
  ) async {
    emit(LevelCompletionLoading());
    try {
      final message = await _repository.completeLevel("Level completed");
      emit(LevelCompleted(message: message));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(LevelCompletionError(message: errorMessage));
    }
  }
}
