

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/logic/search/seach_state.dart';
import 'package:makefriend/logic/search/search_bloc.dart';
import 'package:makefriend/logic/search/search_event.dart';
import 'package:makefriend/ui/thongtinuser_page.dart';

class ThongTinKetBan extends StatefulWidget {
  const ThongTinKetBan({super.key});

  @override
  State<ThongTinKetBan> createState() => _ThongTinKetBanState();
}

class _ThongTinKetBanState extends State<ThongTinKetBan> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SearchBloc>().add(FetchListKetBan(id: myUser.maSinhVien));
  }

  @override
  Widget build(BuildContext context) {

  bool isEnable = false;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft, color: Colors.white, size: 20,),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Danh Sách Kết Bạn',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: FitnessAppTheme.colorAppBar,
        ),
        body: Container(
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
                      final user = state.list[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            // Ảnh đại diện
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://loremflickr.com/100/100/people?random=$index',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Tên người dùng
                            Expanded(
                              child: Text(
                                user.hoTen,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Nút Đồng ý
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: isEnable ? null: () {
                                    context.read<SearchBloc>().add(
                                      AceptKetBan(
                                        guinhan: user.maSinhVien,
                                        nguoigui: myUser.maSinhVien,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  child: const Text(
                                    "Đồng ý",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                ElevatedButton(
                                  onPressed: isEnable ? null: () {
                                    context.read<SearchBloc>().add(
                                      XoaKetBan(
                                        guinhan: user.maSinhVien,
                                        nguoigui: myUser.maSinhVien,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  child: const Text(
                                    "Từ chối",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                else{
                  return const Center(child: Text("No Data"),);
                }

              }
          ),
        )
    );
  }
}
