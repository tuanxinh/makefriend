import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/auth_repository.dart';
import 'package:makefriend/data/repository/danhgia_repository.dart';
import 'package:makefriend/data/repository/profile_repository.dart';
import 'package:makefriend/logic/auth/auth_bloc.dart';
import 'package:makefriend/logic/danhgia/danhgia_bloc.dart';
import 'package:makefriend/logic/profile/profile_bloc.dart';
import 'package:makefriend/ui/EditProfile.dart';
import 'package:makefriend/ui/danhgiacuatoi_page.dart';
import 'package:makefriend/ui/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? users;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      users = myUser;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = users!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: FitnessAppTheme.colorAppBar,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.anhDaiDien != null
                            ? NetworkImage(user.anhDaiDien!)
                            : const AssetImage("assets/images/avtprofile.png")
                        as ImageProvider,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.hoTen,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile Information",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () async{
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BlocProvider(
                            create: (context) => ProfileBloc(repository: ProfileRepository(apiService: ApiService())),
                              child: EditProfilePage())),
                        );

                        if (updatedUser != null && updatedUser is User) {
                          setState(() {
                            users = updatedUser;
                            myUser = updatedUser;
                          });
                        }
                      },
                      child: const Icon(Icons.edit, color: Colors.indigo),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoTile(Icons.email, "Email", user.email),
                _buildInfoTile(Icons.cake, "Ngày sinh", user.ngaySinh ?? "N/A"),
                _buildInfoTile(Icons.wc, "Giới tính", user.gioiTinh ?? "N/A"),
                _buildInfoTile(Icons.school, "Trường", user.truong ?? "N/A"),
                _buildInfoTile(Icons.book, "Ngành", user.nganhHoc ?? "N/A"),
                _buildInfoTile(Icons.class_, "Lớp", user.lop ?? "N/A"),
                _buildInfoTile(Icons.lightbulb, "Kỹ năng", user.kyNang ?? "N/A"),
                _buildInfoTile(Icons.favorite, "Sở thích", user.soThich ?? "N/A"),
                _buildInfoTile(Icons.description, "Mô tả", user.moTa ?? "N/A"),
                _buildInfoTile(Icons.calendar_today, "Tạo", user.ngayTao ?? "N/A"),

                const Divider(height: 32),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size(250, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {

                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => DanhGiaBloc(repository: DanhgiaRepository(apiService: ApiService())),
                      child: DanhGiaCuaToiPage(user: myUser,),
                    ),
                  ),

                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reviews, color: Colors.white),
                  Text(
                    " Xem review",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          /// Nút đăng xuất
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                fixedSize: const Size(250, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AuthBloc(repository: AuthRepository(apiService: ApiService())),
                      child: LoginPage(),
                    ),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white),
                  Text(
                    " Log Off",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row( 
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }



}
