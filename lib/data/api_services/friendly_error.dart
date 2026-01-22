import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:next_kick/data/api_services/app_api_services.dart';

class FriendlyError {
  static String getMessage(dynamic error) {
    try {
      if (error is NoInternetException) return error.message;

      if (error is DioException) {
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        debugPrint(
          '🔥 Dio Error caught: $statusCode -> ${error.response?.data}',
        );

        // Extract message from response data
        String extractMessage(dynamic data) {
          if (data == null) return 'Something went wrong.';

          // Handle string responses
          if (data is String && data.isNotEmpty) return data;

          // Handle map responses
          if (data is Map) {
            // First check if there's an 'errors' wrapper object
            if (data['errors'] != null && data['errors'] is Map) {
              data = data['errors']; // Unwrap the errors object
            }

            // Check common error keys
            final possibleKeys = [
              'non_field_errors',
              'message',
              'error',
              'detail',
              'email',
              'password',
            ];

            for (final key in possibleKeys) {
              if (data[key] != null) {
                final value = data[key];

                // Handle list of errors (e.g., ['Invalid email', 'Email required'])
                if (value is List && value.isNotEmpty) {
                  return value.first.toString();
                }

                // Handle string errors
                if (value is String && value.isNotEmpty) {
                  return value;
                }
              }
            }

            // If no standard key found, try to get first meaningful value
            for (final entry in data.entries) {
              final value = entry.value;

              if (value is String && value.isNotEmpty) {
                return value;
              }

              if (value is List && value.isNotEmpty) {
                final first = value.first;
                if (first is String) return first;
              }
            }
          }

          // Handle list responses
          if (data is List && data.isNotEmpty) {
            final first = data.first;
            if (first is String) return first;
            if (first is Map && first['message'] != null) {
              return first['message'].toString();
            }
          }

          return 'Something went wrong.';
        }

        // Handle specific status codes
        switch (statusCode) {
          case 400:
            return extractMessage(data);
          case 401:
            // Check if it's a login failure
            final msg = extractMessage(data);
            if (msg.toLowerCase().contains('credential') ||
                msg.toLowerCase().contains('invalid') ||
                msg.toLowerCase().contains('email') ||
                msg.toLowerCase().contains('password')) {
              return msg;
            }
            return 'Invalid email or password.';
          case 403:
            return extractMessage(data);
          case 404:
            return extractMessage(data);
          case 409:
            return extractMessage(data);
          case 422:
            return extractMessage(data);
          case 500:
            return 'Server error. Please try again later.';
          case 503:
            return 'Server is temporarily unavailable.';
          default:
            return extractMessage(data);
        }
      }

      if (error is FormatException) {
        return 'Invalid response format from server.';
      }

      if (error is TypeError) {
        return 'An unexpected type mismatch occurred.';
      }

      if (error is Exception) {
        final msg = error.toString().replaceAll('Exception: ', '');
        if (msg.contains('is not a subtype')) {
          return 'Unexpected data format received. Please try again.';
        }
        return msg.isEmpty ? 'An unknown error occurred.' : msg;
      }

      return 'Unexpected error occurred. Please try again.';
    } catch (e, stack) {
      debugPrint('❌ Error in FriendlyError.getMessage: $e');
      debugPrint(stack.toString());
      return 'An error occurred. Please try again.';
    }
  }

  static void logError(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('❌ Error caught: $error');
    if (error is DioException) {
      debugPrint('Status Code: ${error.response?.statusCode}');
      debugPrint('Response Data: ${error.response?.data}');
    }
    if (stackTrace != null) debugPrint('Stack trace: $stackTrace');
  }
}
