import 'package:makefriend/data/model/message_model.dart';
import 'package:makefriend/data/model/user.dart';

abstract class ChatState {}

// Khi chưa có gì
class ChatInitial extends ChatState {}

// Đã load xong danh sách bạn bè
class FriendsLoaded extends ChatState {
  final List<User> friends;
  FriendsLoaded(this.friends);
}

// Đã chọn bạn chat và tải xong lịch sử
class ChatLoaded extends ChatState {
  final User friend;
  final List<Message> history;
  ChatLoaded(this.friend, this.history);
}

// Có tin nhắn mới (gửi hoặc nhận) cập nhật vào list
class ChatUpdated extends ChatState {
  final List<Message> messages;
  ChatUpdated(this.messages);
}

// Báo lỗi
class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}