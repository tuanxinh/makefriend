

import 'package:makefriend/core/service.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/timkiemModel.dart';
import 'package:makefriend/data/model/user.dart';

class SearchRepository{
  SearchRepository({required this.apiService});
  ApiService apiService;



  Future<ResponseModel> findUsers(String type, String input) async{
    try{
      ResponseModel res = await apiService.get(urlEndpoint: "user/$type/$input",
          fromJson: (json) => ResponseModel.fromJson(json)
      );
      return res;

    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> xoaKetBan(int idgui, int idnhan) async{
    try{
      ResponseModel res = await apiService.delete(urlEndpoint: "ketban/tu-choi2/$idgui/$idnhan",
          fromJson: (json) => ResponseModel.fromJson(json)
      );
      return res;

    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> ketBan(int idgui, int idnhan) async{
    try{
      ResponseModel res = await apiService.get(urlEndpoint: "ketban/$idgui/$idnhan",
          fromJson: (json) => ResponseModel.fromJson(json)
      );
      return res;

    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> aceptketbnan(int idgui, int idnhan) async{
    try{
      ResponseModel res = await apiService.get(urlEndpoint: "ketban/acept-ket-ban/$idgui/$idnhan",
          fromJson: (json) => ResponseModel.fromJson(json)
      );
      return res;
    }catch(e){
      return ResponseModel(status: 0, message: e.toString(), data: []);
    }
  }
  Future<ResponseModel> fetchListKetBan(int id) async{
    try{
      ResponseModel res = await apiService.get(urlEndpoint: "ketban/list-ket-ban/$id",
          fromJson: (json) => ResponseModel.fromJson(json)
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