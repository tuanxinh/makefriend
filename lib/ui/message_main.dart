import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/core/websocket.dart';
import 'package:makefriend/data/model/message_model.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/chat_repository.dart';
import 'package:makefriend/data/repository/search_repository.dart';
import 'package:makefriend/logic/message/chat_bloc.dart';
import 'package:makefriend/logic/message/chat_event.dart';
import 'package:makefriend/logic/message/chat_state.dart';
import 'package:makefriend/logic/search/search_bloc.dart';
import 'package:makefriend/ui/search_page.dart';
import 'package:makefriend/ui/thongtinketban.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../core/FitnessAppTheme.dart';

class Conversation {
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final String time;
  final bool unread;
  final int id;

  Conversation({
    required this.id,
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = false,
  });
}

class MessageMain extends StatefulWidget {
  const MessageMain({super.key});

  @override
  State<MessageMain> createState() => _MessageMainState();
}

class _MessageMainState extends State<MessageMain> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    context.read<ChatBloc>().add(LoadFriends());
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: FitnessAppTheme.colorAppBar,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text('Tin nhắn', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [

          IconButton(
            icon: const Icon(LucideIcons.userPlus, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
              BlocProvider(
                  create: (context) => SearchBloc(repository: SearchRepository(apiService: ApiService())),
                  child: const ThongTinKetBan()
              )));
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendsLoaded) {
            return ListView.builder(
              itemCount: state.friends.length,
              itemBuilder: (context, index) {
                final user = state.friends[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Stack(
                    children: [
                      const CircleAvatar(radius: 28, backgroundImage: NetworkImage("https://placebear.com/200/300")),
                      if (true)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                    ],
                  ),
                  title: Text(user.hoTen, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text("cc", maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text("cc", style: TextStyle(color: Colors.grey[600], fontSize: 12)),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ChatBloc>(),
                            child: MessageDetail(friend: user),
                          ),
                        ),
                      );
                    }

                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) =>  BlocProvider(
                  //         create: (_) => ChatBloc(
                  //           ChatRepository(apiService: ApiService()),
                  //           WebSocketService('${API_SERVER}ws'),
                  //         ),
                  //         child: MessageDetail(friend: user,),
                  //       ),
                  //     ),
                  //   );
                  //   //context.read<ChatBloc>().add(LoadFriends());
                  // },


                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text('Lỗi: ${state.error}'));
          }
          return const Center(child: Text('Không có dữ liệu'));
        },
      )
    );
  }
}

class MessageDetail extends StatefulWidget {
  final User friend;
  const MessageDetail({Key? key, required this.friend}) : super(key: key);

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ChatBloc>().add(SelectFriend(widget.friend));
  }


  void send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(text, widget.friend));
    _controller.text = "";
  }

  Future<void> downloadAndOpenFile(BuildContext context, String fileName, String url) async {
    try {
      final response = await http.get(Uri.parse("${API_SERVER}$url"));
      print("${API_SERVER}$url");

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$fileName';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải file: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải hoặc mở file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitnessAppTheme.colorAppBar,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: (){
            context.read<ChatBloc>().add(LoadFriends());
            Navigator.pop(context);
          },
        ),
        foregroundColor: Colors.white,
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoaded) {
              return Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage("https://placebear.com/200/300")),
                  const SizedBox(width: 8),
                  Text(state.friend.hoTen),
                ],
              );
            }
            return const Text('Chat');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                List<Message> messages = [];
                if (state is ChatLoaded) {
                  messages = state.history;
                } else if (state is ChatUpdated) {
                  messages = state.messages;
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {


                    final msg = messages[messages.length - 1 - index];

                    String myMessage = msg.noiDung;
                    String fileName = "";
                    String fileUrl = "";
                    bool image = false;
                    if(msg.noiDung.contains("[file]")){
                      final parts = msg.noiDung.replaceFirst('[file]', '').split('|');
                       fileName = parts[0];
                       fileUrl = parts[1];
                       myMessage = "[file] ${fileName}";
                       if(fileName.contains("jpg") || fileName.contains("png")){
                         image = true;
                       }
                    }
                    if(msg.noiDung.contains("[img]")){
                      final parts = msg.noiDung.replaceAll('[img]', '');
                      fileName = "IMG";
                      fileUrl = parts;
                      myMessage = "[file] ${fileName}";
                      image = true;
                    }


                    bool isMe = myUser.maSinhVien == msg.guiId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: InkWell(
                        onTap: !myMessage.contains("[file]") ? null : () async {
                          print("Click dowload");
                          await downloadAndOpenFile(context, fileName.trim(), fileUrl.trim());
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              image ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            "$API_SERVER$fileUrl",
                            width: 200, // Kích thước nhỏ
                            fit: BoxFit.cover,
                          ),
                        ) :
                              Text(myMessage, style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                               // decoration: myMessage.contains("[File]") ? TextDecoration.underline : TextDecoration.none
                              )),
                              const SizedBox(height: 4),
                              Text("12:00", style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.black54)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(icon: const Icon(LucideIcons.paperclip),
                    onPressed: () async{
                  //context.read<ChatBloc>().add(FileSelectedEvent());
                      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                      if(result == null) return;
                      final file = File(result.files.single.path!);
                      print("Result: ${file}");
                      context.read<ChatBloc>().add(FileSelectedEvent(url: file,friend: widget.friend));

                }),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Nhập tin nhắn...'),
                    onSubmitted: (_) => send(),
                  ),
                ),
                IconButton(icon: const Icon(LucideIcons.send),
                    onPressed:() {
                      send();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

