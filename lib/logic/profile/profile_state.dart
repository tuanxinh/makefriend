


import 'package:makefriend/data/model/timkiemModel.dart';

class ProfileState {}

class ProfileInitial extends ProfileState{}
class ProfileInProgress extends ProfileState{}
class ProfileSuccess extends ProfileState{
  DanhSachModel list;
  ProfileSuccess({required this.list});
}
class ProfileFailure extends ProfileState{
  String message;
  ProfileFailure({required this.message});
}

class ProfileNotify extends ProfileState{
  String message;
  ProfileNotify({required this.message});
}
