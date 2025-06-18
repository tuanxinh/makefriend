

import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/timkiemModel.dart';

class ProfileRepository{

  ProfileRepository({required this.apiService});

  ApiService apiService;
  Future<ResponseModel> updateInformation(var data) async{
    try{

      ResponseModel res = await apiService.put(
          urlEndpoint: "user/thong-tin-ca-nhan2/${myUser.maSinhVien}",
          fromJson: (json) => ResponseModel.fromJson(json),
          data: data
      );
      return res;
    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> getInfomation() async{
    try{

      ResponseModel res = await apiService.get(
          urlEndpoint: "user/thong-tin-ca-nhan2/${myUser.maSinhVien}",
          fromJson: (json) => ResponseModel.fromJson(json),
      );
      return res;
    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel<DanhSachModel>> getDanhSachTimKiem() async {
    try {
      ResponseModel<DanhSachModel> res = await apiService.get<ResponseModel<DanhSachModel>>(
        urlEndpoint: "user/get-tim-kiem",
        fromJson: (json) => ResponseModel.fromJson2(json, (data) => DanhSachModel.fromJson(data)),
      );
      print(res.data);
      return res;
    } catch (e) {
      return ResponseModel(status: 0, message: e.toString(), data: null);
    }
  }

}