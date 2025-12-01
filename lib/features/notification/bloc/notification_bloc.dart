import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/models/notification_model.dart';
import 'package:next_kick/data/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await _repository.getNotification(
        expectedUserType: event.userType,
      );

      if (notifications.isEmpty) {
        emit(NotificationEmpty());
      } else {
        emit(NotificationLoaded(notifications));
      }
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(NotificationError(errorMessage));
    }
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsRead event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationMarkingRead());
    try {
      await _repository.markAllNotificationsRead();
      emit(NotificationMarkedRead());
    } catch (e) {
      final errorMessage = FriendlyError.getMessage(e);
      emit(NotificationError(errorMessage));
    }
  }
}
