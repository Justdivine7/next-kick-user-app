import 'package:equatable/equatable.dart';
import 'package:next_kick/data/models/player_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class PlayerProfileLoading extends UserState {}

class PlayerProfileLoaded extends UserState {
  final PlayerModel user;

  const PlayerProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class PlayerProfileError extends UserState {
  final String message;
  const PlayerProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PlayerProfileUpdateLoading extends UserState {}

class PlayerProfileUpdateSuccessful extends UserState {
  final PlayerModel player;

  const PlayerProfileUpdateSuccessful(this.player);

  @override
  List<Object?> get props => [player];
}

class PlayerProfileUpdatedError extends UserState {
  final String message;
  const PlayerProfileUpdatedError({required this.message});

  @override
  List<Object?> get props => [message];
}
