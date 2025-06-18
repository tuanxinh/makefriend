import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/data/model/timkiemModel.dart';
import 'package:makefriend/logic/search/seach_state.dart';
import 'package:makefriend/logic/search/search_bloc.dart';
import 'package:makefriend/logic/search/search_event.dart';
import 'package:makefriend/logic/timkiem/timkiem_bloc.dart';
import 'package:makefriend/logic/timkiem/timkiem_event.dart';
import 'package:makefriend/logic/timkiem/timkiem_state.dart';
import 'package:makefriend/ui/thongtinuser_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {





  TextEditingController txtSearch = TextEditingController();

  TruongModel? _selectedTruong;
  NganhModel? _selectedNganh;
  LopHocModel? _selectedLop;

  List<NganhModel> _filteredNganh = [];
  List<LopHocModel> _filteredLop = [];

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   context.read<TimkiemBloc>().add(TimKiemTruong());
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TimkiemBloc>().add(TimKiemTruong());
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Tìm kiếm',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: FitnessAppTheme.colorAppBar,
      ),
      body: Column(
        children: [
          BlocBuilder<TimkiemBloc, TimkiemState>(
              builder: (context, state){
                 if(state is TimKiemFailure){
                   return Center(child: Text(state.text),);
                 }
                 if(state is TimKiemSuccess){

                   final List<TruongModel> _searchByTruong = state.list.truong;
                   final List<NganhModel> _searchByNganh = state.list.nganh;
                   final List<LopHocModel> _searchByLop = state.list.lop;
                   return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    //color: Colors.red,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4, // 7 phần
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter Information";
                                    }
                                    return null;
                                  },
                                  controller: txtSearch,
                                  maxLength: 32,
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  decoration: const InputDecoration(
                                      counterText: "",
                                      prefixIcon: Icon(Icons.search),
                                      labelText: "ID",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 73, 169, 248)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 243)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ElevatedButton(
                                    onPressed: () {
                                      print('Type: ${_selectedTruong} - Input: ${txtSearch.text}');
                                      context.read<SearchBloc>().add(SearchStart(type: "ID", input: txtSearch.text));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        fixedSize: const Size(70, 45),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        )
                                    ),
                                    child: const Text(
                                      "Tìm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17

                                      ),
                                    )
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ElevatedButton(
                                    onPressed: () {
                                      String type;
                                      String input;
                                      if(_selectedLop != null){
                                        type = "lopHoc";
                                        input = _selectedLop!.tenLop;
                                      }
                                      else if(_selectedNganh != null){
                                        type = "nganhHoc";
                                        input = _selectedNganh!.tenNganh;
                                      }
                                      else if(_selectedTruong != null){
                                        type = "truong";
                                        input = _selectedTruong!.tenTruong;
                                      }else{
                                        showCustomSnackBar(
                                            message: "Hãy chọn tiêu chí",
                                            context: context,
                                            contentType: ContentType.failure,
                                            title: "Thông Báo"
                                        );
                                        return;
                                      }
                                      if(_selectedTruong != null && _selectedNganh == null){
                                        showCustomSnackBar(
                                            message: "Hãy chọn ngành",
                                            context: context,
                                            contentType: ContentType.failure,
                                            title: "Thông Báo"
                                        );
                                        return;
                                      }

                                      context.read<SearchBloc>().add(SearchStart(type: type, input: input));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        fixedSize: const Size(70, 45),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        )
                                    ),
                                    child: const Text(
                                      "Lọc",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17

                                      ),
                                    )
                                ),
                              ),
                            ),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 5),
                          child: DropdownButtonFormField<TruongModel>(

                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Trường',
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
                          padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 5),
                          child: DropdownButtonFormField<NganhModel>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Ngành',
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
                          padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 5),
                          child: DropdownButtonFormField<LopHocModel>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Lớp',
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




                      ],
                    ),

                  );
                 }
                 else {
                   return Center(child: Text("Có lỗi xảy ra"),);
                 }


              }),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
             // color: Colors.red,
              child: BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state){

                    if(state is NotificationSearch){
                      showCustomSnackBar(
                        message: state.message,
                        context: context,
                        contentType: ContentType.success,
                        title: "Success"
                      );
                    }

                  },
                  builder: (context, state) {
                    if(state is SearchInProgress){
                      return const CircularProgressIndicator();
                    }
                    else if(state is SearchFailure){
                      return Center(child: Text(state.message),);
                    }
                    else if(state is SearchSuccess){
                      return ListView.builder(
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                           return InkWell(
                             onTap: (){
                               Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => ThongTinUserPage(user: state.list[index])),
                               );
                             },
                             child: Container(
                               margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              height: 110,
                              decoration: BoxDecoration(
                               // color: Colors.blue,
                                    border: Border.all(width: 1, style: BorderStyle.solid,color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                // boxShadow: const [
                                //   BoxShadow(
                                //     color: Color.fromRGBO(0, 0, 0, 0.35),
                                //     blurRadius: 5,
                                //     spreadRadius: 0,
                                //     offset: Offset(1, 3),
                                //   ),
                               // ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromRGBO(9, 30, 66, 0.25),
                                              blurRadius: 1,
                                              spreadRadius: 0,
                                              offset: Offset(0, 1),
                                            ),
                                            BoxShadow(
                                              color: Color.fromRGBO(9, 30, 66, 0.13),
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Image.network('https://loremflickr.com/320/240/cartoon?random=1', fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                                      child: Container(
                                        height: 90,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                 Expanded(
                                                  child: Text(
                                                    state.list[index].hoTen,
                                                    style: const TextStyle(
                                                        fontSize: 17, fontWeight: FontWeight.bold,
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),

                                                InkWell(
                                                    onTap: (){
                                                      context.read<SearchBloc>().add(KetBan(
                                                          guinhan: state.list[index].maSinhVien,
                                                          nguoigui:  myUser.maSinhVien ));
                                                    },
                                                    child: const Icon(Icons.add, color: Colors.blueAccent, size: 24,)
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Ngành: ${state.list[index].nganhHoc}' ,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Kỹ năng: ${state.list[index].kyNang}' ,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                                                       ),
                           );
                        }


                      );
                    }
                    else{
                      return const Center(child: Text("No Data"),);
                    }

                  }
              ),
            ),
          )
        ],
      )
    );
  }
}


Widget showMenuItem(){
  return Container(

  );
}
