

import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/ResponseModel.dart';

class AuthRepository {
  AuthRepository({required this.apiService});
  ApiService apiService;

  Future<ResponseModel> register(String email, String password, String name) async{
    try{
      var data = {
        "email" : email,
        "matKhau" : password,
        "hoTen" : name,
      };
      ResponseModel res = await apiService.post(
          urlEndpoint: "user/dang-ky-v",
          fromJson: (json) => ResponseModel.fromJson(json),
          data: data
      );
      return res;
    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }


  Future<ResponseModel> login(String email, String password) async{
    try{
      var data = {
        "email" : email,
        "matKhau" : password
      };
      ResponseModel res = await apiService.post(
          urlEndpoint: "user/dang-nhap-v",
          fromJson: (json) => ResponseModel.fromJson(json),
          data: data
      );
      return res;
    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
}