import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/logic/danhgia/danhgia_bloc.dart';
import 'package:makefriend/logic/danhgia/danhgia_event.dart';
import 'package:makefriend/logic/danhgia/danhgia_state.dart';

class DanhGiaBanHoc extends StatefulWidget {
  const DanhGiaBanHoc({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<DanhGiaBanHoc> createState() => _DanhGiaBanHocState();
}

class _DanhGiaBanHocState extends State<DanhGiaBanHoc> {

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

    print('Tần suất trao đổi: $_rateExchange');
    print('Nói chuyện: $_rateConversation');
    print('Tương tác: $_rateInteraction');
    print('Năng lực học: $_rateLearning');
    print('Độ thân thiện: $_rateFriendliness');
    print('Nhận xét: ${_commentController.text}');

    context.read<DanhGiaBloc>().add(DanhGiaNe(
        nguoiDanhGia: myUser.maSinhVien,
        nguoiDuocDanhGia: widget.user.maSinhVien,
        tieuchi1: _rateExchange,
        tieuchi2: _rateConversation,
        tieuchi3: _rateInteraction,
        tieuchi4: _rateLearning,
        tieuchi5: _rateFriendliness,
        nhanXet: _commentController.text
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cảm ơn bạn đã gửi đánh giá!')),
    );
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
            if(state is ThongBaoDanhGia){
              showCustomSnackBar(context: context, message: state.message, contentType: ContentType.success);
            }
          },
          builder: (context, state) =>
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề chính
              const Text(
                'Đánh giá bạn học',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Mục Tần suất trao đổi
              _buildRatingItem(
                label: 'Tần suất trao đổi:',
                ratingValue: _rateExchange,
                onRatingChanged: (selected) {
                  setState(() {
                    _rateExchange = selected;
                  });
                },
              ),

              // Mục Nói chuyện
              _buildRatingItem(
                label: 'Nói chuyện:',
                ratingValue: _rateConversation,
                onRatingChanged: (selected) {
                  setState(() {
                    _rateConversation = selected;
                  });
                },
              ),

              // Mục Tương tác
              _buildRatingItem(
                label: 'Tương tác:',
                ratingValue: _rateInteraction,
                onRatingChanged: (selected) {
                  setState(() {
                    _rateInteraction = selected;
                  });
                },
              ),

              // Mục Năng lực học
              _buildRatingItem(
                label: 'Năng lực học:',
                ratingValue: _rateLearning,
                onRatingChanged: (selected) {
                  setState(() {
                    _rateLearning = selected;
                  });
                },
              ),

              // Mục Độ thân thiện
              _buildRatingItem(
                label: 'Độ thân thiện:',
                ratingValue: _rateFriendliness,
                onRatingChanged: (selected) {
                  setState(() {
                    _rateFriendliness = selected;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Phần Nhận xét
              const Text(
                'Nhận xét:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Nhận xét của bạn...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nút Gửi đánh giá
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Gửi đánh giá', style: TextStyle(color: Colors.white),),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Ví dụ FitnessAppTheme (nếu bạn đã định nghĩa sẵn chỗ khác, có thể bỏ phần này)
class FitnessAppTheme {
  static const Color colorAppBar = Color(0xFF1976D2);
}
