import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:next_kick/data/models/player_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchPlayerProfile extends UserEvent {
  const FetchPlayerProfile();

  @override
  List<Object?> get props => [];
}

class UpdatePlayerProfile extends UserEvent {
  final PlayerModel updatedData;
  final File? profilePicture;

  const UpdatePlayerProfile({required this.updatedData, this.profilePicture});
  @override
  List<Object?> get props => [updatedData, profilePicture];
}
