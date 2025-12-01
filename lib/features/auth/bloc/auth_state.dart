import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class TeamSignUpLoading extends AuthState {}

class TeamSignUpSuccessful extends AuthState {
  final String userType;
  const TeamSignUpSuccessful({required this.userType});

  @override
  List<Object?> get props => [userType];
}

class TeamSignUpFailure extends AuthState {
  final String error;
  const TeamSignUpFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PlayerSignUpLoading extends AuthState {}

class PlayerSignUpSuccessful extends AuthState {
  final String userType;
  const PlayerSignUpSuccessful({required this.userType});

  @override
  List<Object?> get props => [userType];
}

class PlayerSignUpFailure extends AuthState {
  final String error;
  const PlayerSignUpFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoginLoading extends AuthState {}

class LoginSuccessful extends AuthState {
  final String userType;
  final dynamic user;
  const LoginSuccessful({required this.userType, required this.user});

  bool get isTeam => userType == 'team';
  bool get isPlayer => userType == 'player';

  @override
  List<Object?> get props => [userType, user];
}

class LoginFailure extends AuthState {
  final String error;
  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccessful extends AuthState {
  final String message;
  const ForgotPasswordSuccessful({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordFailure extends AuthState {
  final String error;
  const ForgotPasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ResendCodeLoading extends AuthState {}

class ResendCodeSuccessful extends AuthState {
  final String message;
  const ResendCodeSuccessful({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResendCodeFailure extends AuthState {
  final String error;
  const ResendCodeFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccessful extends AuthState {
  final String message;
  const ResetPasswordSuccessful({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends AuthState {
  final String error;
  const ResetPasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

class LogoutError extends AuthState {
  final String error;
  const LogoutError({required this.error});

  @override
  List<Object?> get props => [error];
}
