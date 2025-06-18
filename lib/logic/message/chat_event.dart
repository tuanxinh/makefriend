import 'dart:io';

import 'package:makefriend/data/model/message_model.dart';
import 'package:makefriend/data/model/user.dart';

abstract class ChatEvent {}

class LoadFriends extends ChatEvent {}
class SelectFriend extends ChatEvent {
  final User friend;
  SelectFriend(this.friend);
}
class LoadHistory extends ChatEvent {}
class ConnectSocket extends ChatEvent {}
class MessageReceived extends ChatEvent {
  final Message message;
  MessageReceived(this.message);
}
class SendMessage extends ChatEvent {
  final User friend;
  final String content;
  SendMessage(this.content, this.friend);
}

class FileSelectedEvent  extends ChatEvent{
  final User friend;
  File url;
  FileSelectedEvent({required this.url, required this.friend});
}


