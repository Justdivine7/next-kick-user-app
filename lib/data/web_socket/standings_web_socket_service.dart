import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:next_kick/data/models/standing_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StandingsWebSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  final int _reconnectDelaySeconds = 5;
  Function(List<StandingModel>)? _onUpdate;
  String? _token;
  bool _isConnected = false;

  void connect(String token, Function(List<StandingModel>) onStandingsUpdate) {
    _token = token;
    _onUpdate = onStandingsUpdate;
    _connect();
  }

  void _connect() {
    if (_token == null) {
      debugPrint("❌ Cannot connect: No token");
      return;
    }

    try {
      debugPrint("🔌 Connecting to standings WebSocket...");

      _channel = WebSocketChannel.connect(
        Uri.parse("wss://nextkick.net/ws/standings/?token=$_token"),
      );

      _isConnected = true;
      debugPrint("✅ WebSocket connected");

      _channel!.stream.listen(
        (message) {
          debugPrint("📨 Raw WS message received: $message");

          try {
            final decoded = jsonDecode(message);
            debugPrint("📦 Decoded message: $decoded");

            // Handle initial standings list
            if (decoded['type'] == 'standings_list') {
              final List data = decoded['data'];
              debugPrint(
                "📊 Processing ${data.length} standings (initial list)",
              );

              final standings =
                  data.map((e) => StandingModel.fromJson(e)).toList();

              debugPrint(
                "✅ Parsed ${standings.length} standings, calling callback",
              );
              _onUpdate?.call(standings);
            }
            // Handle update events
            else if (decoded['event'] == 'updated') {
              final List data = decoded['data'];
              debugPrint(
                "🔄 Processing ${data.length} standings (update event)",
              );

              // Update format has different structure: "team" instead of "team_name"
              final standings =
                  data.map((e) {
                    return StandingModel(
                      id: e['id'] as String,
                      teamName:
                          e['team'] as String, // Note: 'team' not 'team_name'
                      points: e['points'] as int,
                    );
                  }).toList();

              debugPrint(
                "✅ Parsed ${standings.length} standings from update, calling callback",
              );
              _onUpdate?.call(standings);
            } else {
              debugPrint(
                "⚠️ Unknown message type/event: ${decoded['type'] ?? decoded['event']}",
              );
            }
          } catch (e, stackTrace) {
            debugPrint("❌ Error processing message: $e");
            debugPrint("Stack trace: $stackTrace");
          }
        },
        onError: (error) {
          debugPrint("❌ WebSocket error: $error");
          _isConnected = false;
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint("⚠️ WebSocket connection closed");
          _isConnected = false;
          _scheduleReconnect();
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint("❌ Connection error: $e");
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      debugPrint("⏳ Reconnect already scheduled");
      return;
    }

    debugPrint("⏳ Scheduling reconnect in $_reconnectDelaySeconds seconds...");

    _reconnectTimer = Timer.periodic(
      Duration(seconds: _reconnectDelaySeconds),
      (timer) {
        if (!_isConnected) {
          debugPrint("🔄 Attempting to reconnect...");
          _connect();
        } else {
          debugPrint("✅ Reconnected successfully, canceling timer");
          _reconnectTimer?.cancel();
          _reconnectTimer = null;
        }
      },
    );
  }

  void disconnect() {
    debugPrint("🔌 Disconnecting WebSocket...");
    _channel?.sink.close();
    _isConnected = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }
}
