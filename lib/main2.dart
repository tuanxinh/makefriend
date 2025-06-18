import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/websocket.dart';
import 'package:makefriend/data/model/message_model.dart';

void main() async {
  // URL websocket thật của bạn
  final wsUrl = '${API_SERVER}ws';

  // User id của bạn (giả sử là 1)
  final int userId = 2;

  // Tạo service websocket
  final ws = WebSocketService(wsUrl);

  // Kết nối và xử lý tin nhắn nhận về
  ws.connect(userId, (Message message) {
    print('Tin nhắn mới nhận từ ${message.guiId}: ${message.noiDung}');
  });

  print('Đã kết nối WebSocket cho userId = $userId');
  print('Nhập tin nhắn gửi (gõ "exit" để thoát):');

  // Đọc input từ console liên tục
  await for (String? line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    if (line == null || line.toLowerCase() == 'exit') {
      print('Đóng kết nối và thoát.');
      ws.disconnect();
      exit(0);
    }

    // Tạo tin nhắn gửi đi (giả sử gửi cho userId = 2)
    final msg = Message(
      guiId: userId,
      nhanId: 3, // bạn bè nhận tin
      noiDung: line,
    );

    ws.send(msg);
    print('Đã gửi: $line');
  }
}
