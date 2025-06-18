
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/data/model/danhgiacuatoi_model.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/logic/danhgia/danhgia_bloc.dart';
import 'package:makefriend/logic/danhgia/danhgia_event.dart';
import 'package:makefriend/logic/danhgia/danhgia_state.dart';

import '../core/FitnessAppTheme.dart';

class DanhGiaCuaToiPage extends StatefulWidget {
  const DanhGiaCuaToiPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<DanhGiaCuaToiPage> createState() => _DanhGiaCuaToiPageState();
}

class _DanhGiaCuaToiPageState extends State<DanhGiaCuaToiPage> {

  int _rateExchange = 0;       // Tần suất trao đổi
  int _rateConversation = 0;   // Nói chuyện
  int _rateInteraction = 0;    // Tương tác
  int _rateLearning = 0;       // Năng lực học
  int _rateFriendliness = 0;   // Độ thân thiện

  final TextEditingController _commentController = TextEditingController();

  // Hàm xây dãy 5 ngôi sao có thể bấm
  Widget _buildStarRow(int currentRating, ValueChanged<int> onStarTap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            onStarTap(starIndex);
          },
          child: Icon(
            Icons.star,
            size: 32,
            color: (starIndex <= currentRating) ? Colors.amber : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  // Hàm hiển thị một mục đánh giá (label + dòng sao)
  Widget _buildRatingItem({
    required String label,
    required int ratingValue,
    required ValueChanged<int> onRatingChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề mục đánh giá
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // Dòng ngôi sao
          _buildStarRow(ratingValue, onRatingChanged),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    context.read<DanhGiaBloc>().add(FetchMyDanhGia());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Giữ nguyên AppBar giống như trang trước
      appBar: AppBar(
        title: const Text("Đánh giá"),
        backgroundColor: FitnessAppTheme.colorAppBar,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: BlocConsumer<DanhGiaBloc, DanhGiaState>(
          listener: (context, state){
            // if(state is ThongBaoDanhGia){
            //   showCustomSnackBar(context: context, message: state.message, contentType: ContentType.success);
            // }
          },
          builder: (context, state) {
            if (state is DanhGiaInProgress) {
              return const Center(child: CircularProgressIndicator(),);
            }

            else if (state is DanhGiaCuaToiSuccess) {
              List<DanhGiaCuaToi> list = state.lists;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Danh sách đánh giá',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      DanhGiaCuaToi danhGia = list[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Người đánh giá: ${danhGia.hoTen ?? 'Ẩn danh'}",
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              _buildRatingDisplay("Tần suất trao đổi", danhGia.tieuchi1),
                              _buildRatingDisplay("Nói chuyện", danhGia.tieuchi2),
                              _buildRatingDisplay("Tương tác", danhGia.tieuchi3),
                              _buildRatingDisplay("Năng lực học", danhGia.tieuchi4),
                              _buildRatingDisplay("Độ thân thiện", danhGia.tieuchi5),
                              const SizedBox(height: 8),
                              Text("Nhận xét: ${danhGia.nhanXet ?? 'Không có'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            }
            else {
              return const Center(child: Text("No Data"),);
            }
          }
        ),
      ),
    );
  }
  Widget _buildRatingDisplay(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 20,
                color: (index < rating) ? Colors.amber : Colors.grey.shade300,
              );
            }),
          ),
        ],
      ),
    );
  }

}
