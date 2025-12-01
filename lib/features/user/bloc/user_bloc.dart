import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/repositories/player_repository.dart';
import 'package:next_kick/features/user/bloc/user_event.dart';
import 'package:next_kick/features/user/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final PlayerRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchPlayerProfile>(_onFetchUserProfile);
    on<UpdatePlayerProfile>(_onUpdateUserProfile);
  }

  Future<void> _onFetchUserProfile(
    FetchPlayerProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(PlayerProfileLoading());
    try {
      final user = await userRepository.fetchUserProfile();

      emit(PlayerProfileLoaded(user: user));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(PlayerProfileError(message: errorMessage));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdatePlayerProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(PlayerProfileUpdateLoading());
    try {
      final updatedUser = await userRepository.updateUserProfile(
        event.updatedData,
        event.profilePicture,
      );
      emit(PlayerProfileUpdateSuccessful(updatedUser));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(PlayerProfileUpdatedError(message: errorMessage));
    }
  }
}
