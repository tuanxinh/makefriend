import 'dart:convert';
import 'dart:io';

import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/message_model.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;


class ChatRepository {

  ChatRepository({required this.apiService});
  ApiService apiService;



  Future<ResponseModel> UpLoadFile(File file) async {
    print("UpLoad");
    final uri = Uri.parse('${API_SERVER}file/upload');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final parsed = ResponseModel.fromJson(
        json,
      );
      return parsed;
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }

  }


  /// Lấy thông tin user hiện tại
  Future<User> getCurrentUser() async {
    final res = await apiService.get2('user/nguoi-dung-hien-tai');
    return User.fromJson(res);
  }

  /// Lấy danh sách bạn bè của user
  Future<List<User>> fetchFriends(int userId) async {
    final res = await apiService.get2('user/$userId/ban-be');  // sửa ở đây
    return (res as List).map((e) => User.fromJson(e)).toList();
  }

  /// Lấy lịch sử chat giữa 2 user
  Future<List<Message>> fetchHistory(int guiId, int nhanId) async {
    print('tin-nhan/lich-su?guiId=$guiId&nhanId=$nhanId');
    final res = await apiService.get2('tin-nhan/lich-su?guiId=$guiId&nhanId=$nhanId');  // sửa ở đây

    return (res as List).map((e) => Message.fromJson(e)).toList();
  }
}
