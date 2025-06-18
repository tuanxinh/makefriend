

import 'package:makefriend/data/model/danhgiacuatoi_model.dart';
import 'package:makefriend/data/model/ranking.dart';
import 'package:makefriend/data/model/user.dart';

class DanhGiaState {}

class DanhGiaInitial extends DanhGiaState{}
class DanhGiaInProgress extends DanhGiaState{}
class DanhGiaSuccess extends DanhGiaState{
  List<User> users;
  List<Ranking> ranks;
  DanhGiaSuccess({required this.users, required this.ranks});

}
class DanhGiaFailure extends DanhGiaState{
  String message;
  DanhGiaFailure({required this.message});
}

class ThongBaoDanhGia extends DanhGiaState{
  String message;
  ThongBaoDanhGia({required this.message});
}
class DanhGiaCuaToiSuccess extends DanhGiaState{
  List<DanhGiaCuaToi> lists;
  DanhGiaCuaToiSuccess({required this.lists});

}