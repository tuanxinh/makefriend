import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/ranking.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/danhgia_repository.dart';
import 'package:makefriend/logic/danhgia/danhgia_bloc.dart';
import 'package:makefriend/logic/danhgia/danhgia_event.dart';
import 'package:makefriend/logic/danhgia/danhgia_state.dart';
import 'package:makefriend/ui/danhgia_Page.dart';
import 'package:makefriend/ui/detail_DanhSachNhanXetPage.dart';

class DanhGiaPage extends StatefulWidget {
  const DanhGiaPage({super.key});

  @override
  State<DanhGiaPage> createState() => _DanhGiaPageState();
}

class _DanhGiaPageState extends State<DanhGiaPage> {

   List<User> _friends = [

  ];


   List<Ranking> _rankings = [

    // Thêm các dòng khác nếu cần
  ];

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DanhGiaBloc>().add(FetchDanhSach());
  }

  @override
  Widget build(BuildContext context) {


    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 12.0;
    const double itemSpacing = 12.0;

    final double itemWidth = (screenWidth - horizontalPadding * 2 - itemSpacing * 3) / 4;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Đánh giá"),
        backgroundColor: FitnessAppTheme.colorAppBar,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: BlocConsumer<DanhGiaBloc, DanhGiaState>(
          listener: (context, state){

          },
          builder: (context, state){

            if(state is DanhGiaInProgress){
              return const Center(child:  CircularProgressIndicator(),);
            }else if(state is DanhGiaFailure){
              return Center(child: Text(state.message));
            }
            else if(state is DanhGiaSuccess){

              _friends = state.users;
              _rankings = state.ranks;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tiêu đề Danh Sách Bạn bè
                  const Center(
                    child: Text(
                      'Danh Sách Bạn bè',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _friends.length,
                      separatorBuilder: (_, __) => const SizedBox(width: itemSpacing),
                      itemBuilder: (context, index) {
                        final friend = _friends[index];

                        final double screenWidth = MediaQuery.of(context).size.width;
                        const double horizontalPadding = 12.0;
                        const double itemSpacing = 12.0;
                        final double itemWidth =
                            (screenWidth - horizontalPadding * 2 - itemSpacing * 2) / 3;

                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => DanhGiaBloc(
                                          repository: DanhgiaRepository(apiService: ApiService())),
                                      child: DanhGiaBanHoc(user: friend),
                                    )))
                                    .then((_) {
                                  context.read<DanhGiaBloc>().add(FetchDanhSach());
                                });
                              },
                              child: Container(
                                width: itemWidth,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 32,
                                      backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=1"),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      friend.hoTen,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              right: 2,
                              top: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Xác nhận'),
                                      content: const Text('Bạn có chắc chắn muốn xoá bạn này không?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('Không'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text('Đồng ý'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    context.read<DanhGiaBloc>().add(XoaBanBe(id: friend.maSinhVien));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tiêu đề Xếp hạng bạn học
                  const Center(
                    child: Text(
                      'Xếp hạng bạn học',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),


                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                      MaterialStateProperty.all<Color>(Colors.grey.shade200),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Hạng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Tên',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Điểm tổng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Số người đánh giá',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'Nhận xét',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: _rankings.asMap().entries.map((entry) {
                        final index = entry.key; // Bắt đầu từ 0
                        final ranking = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(Text(ranking.hoTen)),
                            DataCell(Text(ranking.diemTrungBinh.toStringAsFixed(2))),
                            DataCell(Text(ranking.soLuotDanhGia.toString())),
                            DataCell(
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                onPressed: () {
                                  Navigator.push( context, MaterialPageRoute(builder: (_) => DanhSachNhanXetPage(danhSachNhanXet: ranking.danhSachNhanXet,)));
                                },
                                child: const Text(
                                  'Xem nhận xét',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );}
              else {
                return const Center(child: Text("No Dataa"),);
              }

          },

        ),
      ),
    );
  }
}

// Mẫu model Friend
class Friend {
  final String name;
  final String avatarUrl;

  Friend({required this.name, required this.avatarUrl});
}

// Widget nhỏ hiển thị mỗi Friend (avatar, tên, nút Đánh giá)
class FriendCard extends StatelessWidget {
  final Friend friend;

  const FriendCard({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 12 * 3) / 2,
      // chia 2 phần tử trên mỗi hàng, margin spacing là 12 => (screenWidth - 3*spacing) / 2
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(friend.avatarUrl),
          ),
          const SizedBox(height: 8),
          Text(
            friend.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Xử lý khi nhấn nút Đánh giá
              // Navigator.push(context, MaterialPageRoute(builder: (_) => DanhGiaDetailPage(friend: friend)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Đánh giá',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


// Ví dụ FitnessAppTheme (nếu bạn đã định nghĩa sẵn chỗ khác, có thể bỏ phần này)
class FitnessAppTheme {
  static const Color colorAppBar = Color(0xFF1976D2);
}
