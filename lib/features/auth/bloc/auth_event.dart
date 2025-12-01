import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:next_kick/data/models/player_model.dart';
import 'package:next_kick/data/models/team_model.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// TEAM SIGNUP

class TeamDetailsSubmitted extends AuthEvent {
  final TeamModel team;
  final String password;
  final String confirmPassword;
  final File? teamLogo;

  const TeamDetailsSubmitted({
    required this.team,
    required this.password,
    required this.confirmPassword,
    this.teamLogo,
  });
  @override
  List<Object?> get props => [team, password, confirmPassword, teamLogo];
}

// PLAYER SIGNUP

class PlayerDetailsSubmitted extends AuthEvent {
  final PlayerModel player;
  final String password;
  final String confirmPassword;
  final File? profilePicture;
  const PlayerDetailsSubmitted({
    required this.player,
    required this.password,
    required this.confirmPassword,
    this.profilePicture,
  });
  @override
  List<Object?> get props => [
    player,
    password,
    profilePicture,
    confirmPassword,
  ];
}

// LOGIN

class LoginDetailsSubmitted extends AuthEvent {
  final String email;
  final String password;
  const LoginDetailsSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

// FORGOT PASSWORD

class MailSubmittedOnForgotPassword extends AuthEvent {
  final String email;
  const MailSubmittedOnForgotPassword({required this.email});
  @override
  List<Object?> get props => [email];
}

// RESEND CODE

class ResendCodeRequest extends AuthEvent {
  final String email;
  const ResendCodeRequest({required this.email});
  @override
  List<Object?> get props => [email];
}

// RESET PASSWORD

class ResetPasswordRequest extends AuthEvent {
  final String code;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequest({
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [code, newPassword, confirmPassword];
}

// LOGOUT
class LogoutSubmitted extends AuthEvent {}
