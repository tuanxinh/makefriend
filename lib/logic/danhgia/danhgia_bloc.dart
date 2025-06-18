

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/danhgiacuatoi_model.dart';
import 'package:makefriend/data/model/ranking.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/danhgia_repository.dart';
import 'package:makefriend/logic/danhgia/danhgia_event.dart';
import 'package:makefriend/logic/danhgia/danhgia_state.dart';

class DanhGiaBloc extends Bloc<DanhGiaEvent, DanhGiaState>{
  DanhGiaBloc({required this.repository}) : super(DanhGiaInitial()){
    on<FetchDanhSach>(_fetchDanhsach);
    on<DanhGiaNe>(_danhGiaNe);
    on<FetchMyDanhGia>(_fetchMyDanhGia);
    on<XoaBanBe>(_xoaBanBe);
  }

  final DanhgiaRepository repository;
  void _xoaBanBe(XoaBanBe event,  Emitter<DanhGiaState> emit) async {
    try{
      ResponseModel res = await repository.xoaBanBe(event.id);
      if(res.status == 1){
        add(FetchDanhSach());
      }else{
        emit(DanhGiaFailure(message: res.message));
      }
    }catch(e){
      emit(DanhGiaFailure(message: e.toString()));
    }
  }
  void _fetchMyDanhGia(FetchMyDanhGia event,  Emitter<DanhGiaState> emit) async {
    emit(DanhGiaInProgress());
    try {
      ResponseModel res = await repository.fetDanhGiaCuaToi();
      if(res.status == 1){
        List<DanhGiaCuaToi> ranks = (res.data as List)
            .map((item) => DanhGiaCuaToi.fromJson(item))
            .toList();
        emit(DanhGiaCuaToiSuccess(lists: ranks));

      }else{
        emit(DanhGiaFailure(message: res.message));
      }
    } catch (e) {
      emit(DanhGiaFailure(message: e.toString()));
    }

  }
  void _danhGiaNe(DanhGiaNe event, Emitter<DanhGiaState> emit) async {
    try {
      var payload = {
        "nguoiDanhGia": {
          "maSinhVien": myUser.maSinhVien,
        },
        "nguoiDuocDanhGia": {
          "maSinhVien": event.nguoiDuocDanhGia,
        },
        "tieuchi1": event.tieuchi1,
        "tieuchi2": event.tieuchi2,
        "tieuchi3": event.tieuchi3,
        "tieuchi4": event.tieuchi4,
        "tieuchi5": event.tieuchi5,
        "nhanXet": event.nhanXet,
      };

      ResponseModel res = await repository.danhgiane(payload);

      if (res.status == 1) {

        emit(ThongBaoDanhGia(message: res.message));
      } else {
        emit(ThongBaoDanhGia(message: res.message));
      }
    } catch (e) {
      emit(ThongBaoDanhGia(message: e.toString()));
    }
  }
  void _fetchDanhsach(FetchDanhSach event, Emitter<DanhGiaState> emit) async {
    emit(DanhGiaInProgress());
    try {
      List<User> list = await repository.fetchFriends(myUser.maSinhVien);
      ResponseModel res = await repository.fetchDanhGia();

      if (res.status == 1) {
        List<Ranking> ranks = (res.data as List)
            .map((item) => Ranking.fromJson(item))
            .toList();
        emit(DanhGiaSuccess(users: list, ranks: ranks));
      } else {
        emit(DanhGiaFailure(message: res.message));
      }
    } catch (e) {
      emit(DanhGiaFailure(message: e.toString()));
    }
  }

}