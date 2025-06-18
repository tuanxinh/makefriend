import 'dart:convert';

import 'package:makefriend/core/config.dart';
import 'package:makefriend/data/model/message_model.dart';

import 'package:stomp_dart_client/stomp_dart_client.dart';


class WebSocketService {
  final String url;
  StompClient? _client;

  WebSocketService(this.url);
  bool _connected = false;
  void connect(int userId, void Function(Message) onMessage) {
    if (_connected || myUser.maSinhVien == null) return;
    _client = StompClient(
      config: StompConfig.sockJS(
        url: '${API_SERVER}ws', // ví dụ: http://localhost:8080/ws
        onConnect: (StompFrame frame) {
          print('🟢 WebSocket connected');
          _connected = true;
          _client?.subscribe(
            destination: '/topic/nhan-tin/$userId',
              callback: (StompFrame frame) {
                if (frame.body != null) {
                  try {
                    final message = Message.fromJson(json.decode(frame.body!));
                    //print('Tin nhắn mới nhận từ ${message.guiId}: ${message.noiDung}');
                    onMessage(message);
                  } catch (e) {
                    print('❌ Lỗi parse Message: $e\nPayload: ${frame.body}');
                  }
                }
            },
          );
        },
        onWebSocketError: (dynamic error) {
          print('❌ WebSocket error: $error');
        },
        onStompError: (frame) {
          print('❗ STOMP error: ${frame.body}');
        },
        onDisconnect: (frame) {
          print('🔌 Disconnected');
        },
        onUnhandledFrame: (frame) {
          print('⚠️ Unhandled frame: ${frame.command}');
        },
        onDebugMessage: (msg) {
          print('🔍 Debug: $msg');
        },
      ),
    );

    _client?.activate();
  }

  void send(Message msg) {
    _client?.send(
      destination: '/app/gui-tin-nhan',
      body: json.encode(msg.toJson()),
    );
  }

  void disconnect() {
    _client?.deactivate();
    print('🔌 WebSocket disconnected');
  }
}
