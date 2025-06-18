

//
// class MessageDetail extends StatefulWidget {
//   final Conversation conversation;
//   const MessageDetail({super.key, required this.conversation});
//
//   @override
//   State<MessageDetail> createState() => _MessageDetailState();
// }
//
// class _MessageDetailState extends State<MessageDetail> {
//   final List<Map<String, dynamic>> _messages = [
//     {'text': 'Chào bạn!', 'isMe': false, 'time': '10:31'},
//     {'text': 'Chào bạn, bạn khỏe không?', 'isMe': true, 'time': '10:32'},
//   ];
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: FitnessAppTheme.colorAppBar,
//         leading: IconButton(
//           icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(backgroundImage: NetworkImage(widget.conversation.avatarUrl)),
//             const SizedBox(width: 8),
//             Text(widget.conversation.name),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 return Align(
//                   alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: msg['isMe'] ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(msg['text'], style: TextStyle(color: msg['isMe'] ? Colors.white : Colors.black)),
//                         const SizedBox(height: 4),
//                         Text(msg['time'], style: const TextStyle(fontSize: 10, color: Colors.white70)),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(LucideIcons.paperclip),
//                   onPressed: () {
//                     // Xử lý gửi tài liệu
//                   },
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                         hintText: 'Nhập tin nhắn...'
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(LucideIcons.send),
//                   onPressed: () {
//                     if (_controller.text.isNotEmpty) {
//                       setState(() {
//                         _messages.add({
//                           'text': _controller.text,
//                           'isMe': true,
//                           'time': TimeOfDay.now().format(context),
//                         });
//                         _controller.clear();
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

