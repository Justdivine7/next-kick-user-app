import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

double getScreenHeight(BuildContext context, double fraction) =>
    MediaQuery.of(context).size.height * fraction;
double getScreenWidth(BuildContext context, double fraction) =>
    MediaQuery.of(context).size.width * fraction;

String? validateField({required String? value, required String fieldName}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

String? validatePassword({required String? value, required String fieldName}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  if (value.length < 6) {
    return '$fieldName must be at least 6 characters';
  }
  return null;
}

String? validateEmail({required String? value, String fieldName = 'Email'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }

  // Simple email regex
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value.trim())) {
    return 'Enter a valid $fieldName';
  }

  return null;
}

PageRouteBuilder createFadeTransition(
  Widget targetScreen, {
  Duration duration = const Duration(milliseconds: 300),
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return FadeTransition(opacity: fadeAnimation, child: child);
    },
  );
}

String shortenYouTubeUrl(String url) {
  final shortPattern = RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]+)');
  final watchPattern = RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)');
  final match = shortPattern.firstMatch(url) ?? watchPattern.firstMatch(url);

  if (match != null && match.groupCount >= 1) {
    final videoId = match.group(1)!;
    return 'https://youtu.be/$videoId';
  }
  return url;
}

Future<String?> shortenUrl(String longUrl) async {
  const bitlyToken = '13ff16efd8e08a911c1e9aba3fca3742f864f96d';
  try {
    final response = await Dio().post(
      'https://api-ssl.bitly.com/v4/shorten',
      options: Options(
        headers: {
          'Authorization': 'Bearer $bitlyToken',
          'Content-Type': 'application/json',
        },
        // Add timeout options
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
      data: {'long_url': longUrl},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['link'];
    }
  } on DioException catch (e) {
    debugPrint('Error shortening URL: ${e.type} - ${e.message}');
    // Return null on any error (network, timeout, etc.)
    return null;
  } catch (e) {
    debugPrint('Unexpected error shortening URL: $e');
    return null;
  }
  return null;
}
