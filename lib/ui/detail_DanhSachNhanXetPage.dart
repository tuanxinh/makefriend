import 'package:flutter/material.dart';

class DanhSachNhanXetPage extends StatelessWidget {
  final List<String> danhSachNhanXet;

  const DanhSachNhanXetPage({
    Key? key,
    required this.danhSachNhanXet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách nhận xét"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: ListView.builder(
          itemCount: danhSachNhanXet.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text("${index + 1}"),
              title: Text(danhSachNhanXet[index]),
            );
          },
        ),
      ),
    );
  }
}
