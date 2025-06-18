
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/websocket.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/message_model.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/chat_repository.dart';
import 'package:makefriend/logic/message/chat_event.dart';
import 'package:makefriend/logic/message/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repo;
  final WebSocketService _ws;
  
  List<Message> _messages = [];

  ChatBloc(this._repo, this._ws) : super(ChatInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<SelectFriend>(_onSelectFriend);
    on<ConnectSocket>(_onConnectSocket);
    on<MessageReceived>(_onMessageReceived);
    on<SendMessage>(_onSendMessage);
    on<FileSelectedEvent>(_fileSelectedEvent);
  }
  Future<void> _fileSelectedEvent(FileSelectedEvent event, Emitter<ChatState> emit) async {
    try{

      ResponseModel res = await _repo.UpLoadFile(event.url);
      print(res.data);
      if(res.status == 200){

        friendChat = event.friend;
        //_ws.disconnect();
        if (myUser.maSinhVien == null || friendChat == null) {
          print("Looi ma");
          return;
        }

        FileUploadResponse file = FileUploadResponse.fromJson(res.data);
        print(file.message);
        add(SendMessage("[file]${file.fileName}|${file.downloadLink}" , friendChat!));
      }else{
        emit(ChatError(res.message));
      }

    }catch(e){
      emit(ChatError(e.toString()));
    }

  }
  Future<void> _onLoadFriends(LoadFriends event, Emitter<ChatState> emit) async {
    try {


      final list = await _repo.fetchFriends(myUser.maSinhVien!);
      print(list.length);
      emit(FriendsLoaded(list));;
      add(ConnectSocket());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onConnectSocket(ConnectSocket event, Emitter<ChatState> emit) {
    if (myUser.maSinhVien == null) return;

    _ws.connect(myUser.maSinhVien!, (Message message) {
      //print('Tin nhắn mới nhận từ ${message.guiId}: ${message.noiDung}');
      add(MessageReceived(message));
    });

   // _ws.connect(myUser.maSinhVien!, (msg) => add(MessageReceived(msg)));
  }

  Future<void> _onSelectFriend(SelectFriend event, Emitter<ChatState> emit) async {
    friendChat = event.friend;
    _messages.clear();
    if (myUser.maSinhVien == null) return;
    final history = await _repo.fetchHistory(myUser.maSinhVien!, friendChat!.maSinhVien);
    _messages = history;
    emit(ChatLoaded(friendChat!, List.from(_messages)));
  }
  

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    print('📩 Nhận được tin nhắn từ ${event.message.guiId} tới ${event.message.nhanId}');

    if (friendChat == null) {
      print('⚠️ Không có bạn bè nào đang được chọn');
      return;
    }

    print('📍Đang chat với: ${friendChat!.maSinhVien}');

    if (event.message.guiId == friendChat!.maSinhVien ||
        event.message.nhanId == friendChat!.maSinhVien) {
      _messages.add(event.message);
      print('✅ Tin nhắn hợp lệ - thêm vào danh sách');
      emit(ChatUpdated(List.from(_messages)));
    } else {
      print('❌ Tin nhắn không khớp với bạn đang chọn');
    }
  }


  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {

    friendChat = event.friend;
    //_ws.disconnect(); 
    if (myUser.maSinhVien == null || friendChat == null) return;

    final msg = Message(guiId: myUser.maSinhVien!, nhanId: friendChat!.maSinhVien, noiDung: event.content);
    print(msg.toJson());
    _ws.send(msg);
    _messages.add(msg);
    emit(ChatUpdated(List.from(_messages)));
  }
}