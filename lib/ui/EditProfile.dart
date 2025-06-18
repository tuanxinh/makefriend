import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/data/model/timkiemModel.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/logic/profile/profile_bloc.dart';
import 'package:makefriend/logic/profile/profile_event.dart';
import 'package:makefriend/logic/profile/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController ngaySinhController;
  late TextEditingController gioiTinhController;
  late TextEditingController truongController;
  late TextEditingController nganhHocController;
  late TextEditingController lopController;
  late TextEditingController kyNangController;
  late TextEditingController soThichController;
  late TextEditingController moTaController;
  late TextEditingController ngayTaoController;
  late TextEditingController hotenController;
  @override
  void initState() {
    super.initState();
    final user = myUser!;
    emailController = TextEditingController(text: user.email ?? "");
    ngaySinhController = TextEditingController(text: user.ngaySinh ?? "");
    gioiTinhController = TextEditingController(text: user.gioiTinh ?? "");
    truongController = TextEditingController(text: user.truong ?? "");
    nganhHocController = TextEditingController(text: user.nganhHoc ?? "");
    lopController = TextEditingController(text: user.lop ?? "");
    kyNangController = TextEditingController(text: user.kyNang ?? "");
    soThichController = TextEditingController(text: user.soThich ?? "");
    moTaController = TextEditingController(text: user.moTa ?? "");
    ngayTaoController = TextEditingController(text: user.ngayTao ?? "");
    hotenController = TextEditingController(text: user.hoTen ?? "");

    context.read<ProfileBloc>().add(ProfileLoad());
  }

  @override
  void dispose() {
    emailController.dispose();
    ngaySinhController.dispose();
    gioiTinhController.dispose();
    truongController.dispose();
    nganhHocController.dispose();
    lopController.dispose();
    kyNangController.dispose();
    soThichController.dispose();
    moTaController.dispose();
    ngayTaoController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Lưu dữ liệu lên server hoặc local

      context.read<ProfileBloc>().add(ProfileEdit(
          emailController: emailController.text.trim(),
          gioiTinhController: gioiTinhController.text.trim(),
          kyNangController: kyNangController.text.trim(),
          lopController: _selectedLop!.id.toString(),
          moTaController: moTaController.text.trim(),
          nganhHocController: _selectedNganh!.id.toString(),
          ngaySinhController: ngaySinhController.text.trim(),
          ngayTaoController: "10-03-2003",
          soThichController: soThichController.text.trim(),
          truongController: _selectedTruong!.id.toString(),
        hoten: hotenController.text,
        context: context
      ));
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool enabled = true, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
    List<TruongModel> _searchByTruong = [];
   List<NganhModel> _searchByNganh = [];
   List<LopHocModel> _searchByLop =  [];

   TruongModel? _selectedTruong;
   NganhModel? _selectedNganh;
   LopHocModel? _selectedLop;

  List<NganhModel> _filteredNganh = [];
  List<LopHocModel> _filteredLop = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: FitnessAppTheme.colorAppBar,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, myUser);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state){
            if(state is ProfileNotify){
              showCustomSnackBar(context: context, message: state.message, contentType: ContentType.success);

            }

          },
          builder: (context, state){
            if(state is ProfileInProgress){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is ProfileFailure){
              return Center(child: Text(state.message),);
            }else if(state is ProfileSuccess){

              final List<TruongModel> _searchByTruong = state.list.truong;
              final List<NganhModel> _searchByNganh = state.list.nganh;
              final List<LopHocModel> _searchByLop = state.list.lop;

              _selectedTruong = _searchByTruong.firstWhere(
                    (t) => t.tenTruong == truongController.text,
                orElse: () => _searchByTruong.first,
              );
              _selectedNganh = _searchByNganh.firstWhere(
                    (t) => t.tenNganh == nganhHocController.text,
                orElse: () => _searchByNganh.first,
              );
              _selectedLop = _searchByLop.firstWhere(
                    (t) => t.tenLop == lopController.text,
                orElse: () => _searchByLop.first,
              );




              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(hotenController, "Name", Icons.nest_cam_wired_stand_sharp),
                    _buildTextField(
                      emailController,
                      "Email",
                      Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email cannot be empty';
                        if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(ngaySinhController, "Date of Birth", Icons.cake),
                    _buildTextField(gioiTinhController, "Gender", Icons.wc),
                    // _buildTextField(truongController, "School", Icons.school),
                    // _buildTextField(nganhHocController, "Major", Icons.book),
                    // _buildTextField(lopController, "Class", Icons.class_),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: DropdownButtonFormField<TruongModel>(

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: truongController.text,
                        ),
                        dropdownColor: Colors.white,
                        value: _selectedTruong,
                        items: _searchByTruong.map((value) {
                          return DropdownMenuItem<TruongModel>(
                            value: value,
                            child: Text(value.tenTruong),
                          );
                        }).toList(),
                        onChanged: (TruongModel? newValue) {
                          setState(() {
                            _selectedTruong = newValue;

                            _filteredNganh = _searchByNganh
                                .where((nganh) => nganh.truongHocId == newValue?.id)
                                .toList();

                            print("Số ngành sau khi lọc: ${_filteredNganh.length}");
                            if (_filteredNganh.isNotEmpty) {
                              print("Ngành đầu tiên: ${_filteredNganh[0].tenNganh}");
                            } else {
                              print("Không tìm thấy ngành nào cho trường này.");
                            }

                            print("Chọn trường: ${newValue?.tenTruong} (ID: ${newValue?.id})");

                            _selectedNganh = null;
                            _filteredLop = [];
                            _selectedLop = null;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: DropdownButtonFormField<NganhModel>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: nganhHocController.text,
                        ),
                        dropdownColor: Colors.white,
                        value: _selectedNganh,
                        items: _filteredNganh.map((value) {
                          return DropdownMenuItem<NganhModel>(
                            value: value,
                            child: Text(value.tenNganh),
                          );
                        }).toList(),
                        onChanged: (NganhModel? newValue) {
                          setState(() {
                            _selectedNganh = newValue;

                            _filteredLop = _searchByLop
                                .where((lop) => lop.nganhHocID == newValue?.id)
                                .toList();

                            _selectedLop = null;

                            print("Chọn ngành: ${newValue?.tenNganh} (ID: ${newValue?.id})");
                          });
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: DropdownButtonFormField<LopHocModel>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: lopController.text,
                        ),
                        dropdownColor: Colors.white,
                        value: _selectedLop,
                        items: _filteredLop.map((value) {
                          return DropdownMenuItem<LopHocModel>(
                            value: value,
                            child: Text(value.tenLop),
                          );
                        }).toList(),
                        onChanged: (LopHocModel? newValue) {
                          setState(() {
                            _selectedLop = newValue;
                            print("Chọn lớp: ${newValue?.tenLop} (ID: ${newValue?.id})");
                          });
                        },
                      ),
                    ),

                    _buildTextField(kyNangController, "Skills", Icons.lightbulb),
                    _buildTextField(soThichController, "Hobbies", Icons.favorite),
                    _buildTextField(moTaController, "Description", Icons.description),

                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save, color:  Colors.white,),
                      label: const Text(
                        "Save",
                        style: const TextStyle(
                            color: Colors.white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: FitnessAppTheme.colorAppBar,
                      ),
                    ),
                  ],
                ),
              );
            }
            else{
              return const Center(child: Text("No data"),);
            }
          },

        ),
      ),
    );
  }
}
