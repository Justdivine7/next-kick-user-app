import 'package:flutter/foundation.dart';
import 'package:next_kick/data/api_services/app_api_services.dart';
import 'package:next_kick/data/models/notification_model.dart';

class NotificationRepository {
  final AppApiClient _apiClient;
  const NotificationRepository(this._apiClient);

  Future<List<NotificationModel>> getNotification({
    required String expectedUserType,
  }) async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.get,
        path: 'admin_app/notifications/',
      );

      final data = response.data;
      final userType = data['user']['user_type'];

      if (userType == expectedUserType) {
        final notifications = data['notifications'] as List<dynamic>;
        // debugPrint(notifications.toString());
        return notifications
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      rethrow;
    }
  }

  Future<void> markAllNotificationsRead() async {
    try {
      final response = await _apiClient.apiCall(
        type: RequestType.post,
        path: 'admin_app/notifications/mark-all-read/',
        requiresAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // debugPrint('All notifications marked as read successfully.');
      } else {
        throw Exception('Failed to mark notifications as read');
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }
}
