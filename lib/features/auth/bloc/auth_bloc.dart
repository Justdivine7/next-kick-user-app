import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/repositories/auth_repository.dart';
import 'package:next_kick/features/auth/bloc/auth_event.dart';
import 'package:next_kick/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<TeamDetailsSubmitted>(_onTeamDetailsSubmitted);
    on<PlayerDetailsSubmitted>(_onPlayerDetailsSubmitted);
    on<LoginDetailsSubmitted>(_onLoginDetailsSubmitted);
    on<LogoutSubmitted>(_onLogoutSubmitted);
    on<MailSubmittedOnForgotPassword>(_onForgotPassword);
    on<ResendCodeRequest>(_onResendCode);
    on<ResetPasswordRequest>(_onResetPassword);
  }

  Future<void> _onTeamDetailsSubmitted(
    TeamDetailsSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(TeamSignUpLoading());
    try {
      final userType = await _repository.signUpTeam(
        team: event.team,
        password: event.password,
        confirmPassword: event.confirmPassword,
        teamLogo: event.teamLogo,
      );
      emit(TeamSignUpSuccessful(userType: userType));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(TeamSignUpFailure(error: errorMessage));
    }
  }

  Future<void> _onPlayerDetailsSubmitted(
    PlayerDetailsSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(PlayerSignUpLoading());
    try {
      final userType = await _repository.signUpPlayer(
        player: event.player,
        password: event.password,
        profilePicture: event.profilePicture,
        confirmPassword: event.confirmPassword,
      );
      emit(PlayerSignUpSuccessful(userType: userType));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(PlayerSignUpFailure(error: errorMessage));
    }
  }

  Future<void> _onLoginDetailsSubmitted(
    LoginDetailsSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _repository.login(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccessful(userType: result.userType, user: result.user));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(LoginFailure(error: errorMessage));
    }
  }

  Future<void> _onForgotPassword(
    MailSubmittedOnForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      await _repository.forgotPassword(email: event.email);
      emit(ForgotPasswordSuccessful(message: 'Password reset email sent.'));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(ForgotPasswordFailure(error: errorMessage));
    }
  }

  Future<void> _onResendCode(
    ResendCodeRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(ResendCodeLoading());
    try {
      await _repository.resendCode(email: event.email);
      emit(ResendCodeSuccessful(message: 'Verification code resent.'));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(ResendCodeFailure(error: errorMessage));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(ResetPasswordLoading());
    try {
      await _repository.resetPassword(
        code: event.code,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      emit(ResetPasswordSuccessful(message: 'Password has been reset.'));
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(ResetPasswordFailure(error: errorMessage));
    }
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutLoading());
    try {
      await _repository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(LogoutError(error: errorMessage));
    }
  }
}
