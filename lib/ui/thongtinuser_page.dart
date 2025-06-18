import 'package:flutter/material.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/data/model/user.dart';

class ThongTinUserPage extends StatefulWidget {
  const ThongTinUserPage({super.key, required this.user});

  final User user;

  @override
  State<ThongTinUserPage> createState() => _ThongTinUserPageState();
}

class _ThongTinUserPageState extends State<ThongTinUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.user.hoTen,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: FitnessAppTheme.colorAppBar,

        ),
        body: Column(
          children: [
            buildInfoRow(Icons.person, "Họ và tên", widget.user.hoTen),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.email, "Email", widget.user.email),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.school, "Trường", widget.user.truong),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.class_, "Lớp", widget.user.lop),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(
                Icons.account_tree_outlined, "Ngành học", widget.user.nganhHoc),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.cake, "Ngày sinh", widget.user.ngaySinh),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.wc, "Giới tính", widget.user.gioiTinh),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.code, "Kỹ năng", widget.user.kyNang),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.favorite, "Sở thích", widget.user.soThich),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.description, "Mô tả", widget.user.moTa),
            const SizedBox(
              height: 5,
            ),
            buildInfoRow(Icons.calendar_today, "Ngày tạo", widget.user.ngayTao),
            const SizedBox(
              height: 5,
            ),
          ],
        ));
  }
}

Widget buildInfoRow(IconData icon, String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 25),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                    text: value ?? "Chưa có thông tin",
                    style: TextStyle(overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
