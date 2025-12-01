import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/models/standing_model.dart';

part 'standings_event.dart';
part 'standings_state.dart';

class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  int _updateCounter = 0;
  StandingsBloc() : super(StandingsInitial()) {
    on<StandingsUpdated>((event, emit) {
      _updateCounter++;
      emit(
        FetchStandingsSuccessful(event.standings, updateCount: _updateCounter),
      );
    });
  }
}
