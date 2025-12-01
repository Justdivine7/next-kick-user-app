import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:next_kick/data/api_services/friendly_error.dart';
import 'package:next_kick/data/local_storage/app_local_storage_service.dart';

enum RequestType { get, post, put, patch, delete, download }

class NoInternetException implements Exception {
  final String message;
  NoInternetException(this.message);

  @override
  String toString() => message;
}

class AppApiClient {
  final Dio _dio;
  final AppLocalStorageService _localStorage;
  final Dio _refreshDio;
  Future<Map<String, String>?>? _refreshingFuture;
  static const String _baseUrl = 'https://www.nextkick.net/';

  // Cache connectivity status to avoid repeated checks
  bool? _lastConnectivityStatus;
  DateTime? _lastConnectivityCheck;
  static const _connectivityCacheDuration = Duration(seconds: 3);

  AppApiClient(this._dio, this._localStorage)
    : _refreshDio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    _dio.options.sendTimeout = const Duration(seconds: 20);
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['requiresAuth'] == true) {
            final accessToken = _localStorage.getAccessToken();
            if (accessToken == null) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Missing access token',
                  type: DioExceptionType.badResponse,
                ),
              );
            }
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          final isMultipart = options.data is FormData;
          if (isMultipart) {
            options.headers['Content-Type'] = 'multipart/form-data';
          } else {
            options.headers['Content-Type'] = 'application/json';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            _lastConnectivityStatus = false;
            _lastConnectivityCheck = DateTime.now();
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: NoInternetException('No internet connection.'),
                type: e.type,
              ),
            );
          }

          if (e.response?.statusCode == 401 &&
              e.requestOptions.path != '/auth/token/refresh/') {
            debugPrint('Token expired. Refreshing.....');

            final int retryCount = e.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount >= 1) {
              return handler.next(e);
            }
            e.requestOptions.extra['retryCount'] = retryCount + 1;

            try {
              final newTokens = await _refreshAccessToken();
              if (newTokens != null) {
                await _localStorage.saveTokens(
                  accessToken: newTokens['access']!,
                  refreshToken: newTokens['refresh']!,
                );

                final opts = e.requestOptions.copyWith(
                  headers: {
                    ...e.requestOptions.headers,
                    'Authorization': 'Bearer ${newTokens['access_token']}',
                  },
                );
                final response = await _dio.fetch(opts);
                return handler.resolve(response);
              }
            } catch (refreshError) {
              debugPrint('Token refresh failed: $refreshError');
              await _localStorage.logout();
            }
          }
          return handler.next(e);
        },
        onResponse: (response, handler) {
          // Update connectivity cache on successful response
          _lastConnectivityStatus = true;
          _lastConnectivityCheck = DateTime.now();
          return handler.next(response);
        },
      ),
    ]);
  }

  /// Ensures only one refresh happens at a time
  Future<Map<String, dynamic>?> _refreshAccessToken() async {
    if (_refreshingFuture != null) return _refreshingFuture;

    _refreshingFuture = _doRefresh().whenComplete(() {
      _refreshingFuture = null;
    });
    return _refreshingFuture;
  }

  Future<Map<String, String>?> _doRefresh() async {
    final refreshToken = _localStorage.getRefreshToken();
    if (refreshToken == null) {
      await _localStorage.logout();
      return null;
    }
    try {
      final response = await _refreshDio.post(
        'api/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['tokens']['access'] as String;
        final newRefreshToken = response.data['tokens']['refresh'] as String;
        return {'access': newAccessToken, 'refresh': newRefreshToken};
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      await _localStorage.logout();
    }
    return null;
  }

  /// Fast connectivity check with caching
  /// Only performs actual check if cache is stale or indicates offline status
  Future<bool> _checkInternetConnectivity() async {
    final now = DateTime.now();

    // Return cached result if:
    // 1. We have a cached status
    // 2. Cache is fresh (< 3 seconds old)
    // 3. Last status was ONLINE (if offline, always recheck)
    if (_lastConnectivityStatus == true &&
        _lastConnectivityCheck != null &&
        now.difference(_lastConnectivityCheck!) < _connectivityCacheDuration) {
      return true;
    }

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(milliseconds: 2000));

      final isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      _lastConnectivityStatus = isConnected;
      _lastConnectivityCheck = now;
      return isConnected;
    } on SocketException catch (_) {
      _lastConnectivityStatus = false;
      _lastConnectivityCheck = now;
      return false;
    } on TimeoutException catch (_) {
      _lastConnectivityStatus = false;
      _lastConnectivityCheck = now;
      return false;
    } catch (_) {
      _lastConnectivityStatus = false;
      _lastConnectivityCheck = now;
      return false;
    }
  }

  Future<Response> apiCall({
    required RequestType type,
    required String path,
    dynamic data,
    Map<String, dynamic>? query,
    String? savePath,
    bool requiresAuth = true,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
    Options? options,
    bool skipConnectivityCheck = false,
  }) async {
    // Pre-flight connectivity check (with caching for performance)
    if (!skipConnectivityCheck) {
      final isConnected = await _checkInternetConnectivity();
      if (!isConnected) {
        throw NoInternetException('No internet connection.');
      }
    }

    try {
      final opts = (options ?? Options()).copyWith(
        extra: {'requiresAuth': requiresAuth},
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          ...?options?.headers,
        },
      );

      switch (type) {
        case RequestType.get:
          return await _dio.get(
            path,
            queryParameters: query,
            options: opts,
            cancelToken: cancelToken,
          );
        case RequestType.post:
          return await _dio.post(
            path,
            data: data,
            queryParameters: query,
            options: opts,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
          );
        case RequestType.put:
          return await _dio.put(
            path,
            data: data,
            queryParameters: query,
            options: opts,
            cancelToken: cancelToken,
          );
        case RequestType.patch:
          return await _dio.patch(
            path,
            data: data,
            queryParameters: query,
            options: opts,
            cancelToken: cancelToken,
          );
        case RequestType.delete:
          return await _dio.delete(
            path,
            data: data,
            queryParameters: query,
            options: opts,
            cancelToken: cancelToken,
          );
        case RequestType.download:
          return await _dio.download(
            path,
            savePath!,
            options: opts,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
          );
      }
    } on NoInternetException {
      // Re-throw as is (no wrapping)
      rethrow;
    } on DioException catch (e) {
      FriendlyError.logError(e);
      // Don't wrap - just rethrow the DioException
      rethrow;
    } catch (error, stack) {
      FriendlyError.logError(error, stack);
      // Re-throw as is
      rethrow;
    }
  }

  Future<Response> updateFcmToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    return await apiCall(
      type: RequestType.post,
      // Use full URL instead of relative path
      path: 'notifications/update-fcm-token/',
      requiresAuth: true,
      data: {'fcm_token': fcmToken, 'device_id': deviceId},
    );
  }
}
