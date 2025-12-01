part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userType;
  final bool forceRefresh;
  const LoadNotifications(this.userType, this.forceRefresh);

  @override
  List<Object?> get props => [userType, forceRefresh];
}

class MarkAllNotificationsRead extends NotificationEvent {}
