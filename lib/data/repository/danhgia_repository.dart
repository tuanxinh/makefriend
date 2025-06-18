

import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/user.dart';

class DanhgiaRepository{
  DanhgiaRepository({required this.apiService});
  final ApiService apiService;

  Future<List<User>> fetchFriends(int userId) async {
    final res = await apiService.get2('user/$userId/ban-be');  // sửa ở đây
    return (res as List).map((e) => User.fromJson(e)).toList();
  }

  Future<ResponseModel> fetchDanhGia() async {
    try {
      final res = await apiService.get(
          urlEndpoint: "danhgia/xep-hang/ban-be/${myUser.maSinhVien}",
          fromJson: (json) => ResponseModel.fromJson(json)
      ).timeout(Duration(seconds: 30));
      return res;
    }
    catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> fetDanhGiaCuaToi() async {
    try {
      final res = await apiService.get(
          urlEndpoint: "danhgia/nguoi-duoc-danh-gia/${myUser.maSinhVien}",
          fromJson: (json) => ResponseModel.fromJson(json)
      ).timeout(Duration(seconds: 30));
      return res;
    }
    catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> xoaBanBe(int id) async {
    try {
      final res = await apiService.delete(
          urlEndpoint: "user/xoabanbe/${myUser.maSinhVien}/$id",
          fromJson: (json) => ResponseModel.fromJson(json)
      ).timeout(Duration(seconds: 30));
      return res;
    }
    catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> danhgiane(var data) async {
    try {

      final res = await apiService.post(
        data: data,
          urlEndpoint: "danhgia/them",
          fromJson: (json) => ResponseModel.fromJson(json)
      ).timeout(Duration(seconds: 30));
      return res;
    }
    catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
}