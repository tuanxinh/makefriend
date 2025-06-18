


import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/profile_repository.dart';
import 'package:makefriend/logic/profile/profile_event.dart';
import 'package:makefriend/logic/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  ProfileBloc({required this.repository}) : super(ProfileInitial()){
    on<ProfileEdit>(_profileEdit);
    on<ProfileLoad>(_profileLoad);
  }

  ProfileRepository repository;

  void _profileEdit(ProfileEdit event, Emitter<ProfileState> emit) async{
    try{
     // final ngaySinhDateTime = parseNgaySinh(event.ngaySinhController);
      //final ngaySinhString = convertToLocalDate(ngaySinhDateTime);
      var data = {
        "hoTen": event.hoten,
        "email" : event.emailController,
        "kyNang" : event.kyNangController,
        "soThich" : event.soThichController,
        "gioiTinh" : event.gioiTinhController,
        "ngaySinh" : event.ngaySinhController,
        "moTa" : event.moTaController,
        "truongId" : event.truongController,
        "nganhId" : event.nganhHocController,
        "lopId" : event.lopController,
      };
      ResponseModel res =await repository.updateInformation(data);
      if(res.status == 1){
        ResponseModel users = await repository.getInfomation();
        if(users.status == 1){
          print(users.data);
          myUser = User.fromJson2(users.data as Map<String, dynamic>);
          //emit(ProfileNotify(message: users.message));
          showCustomSnackBar(context: event.context, message: users.message, contentType: ContentType.success);
          Navigator.pop(event.context, myUser);

        }else{
          emit(ProfileFailure(message: users.message));
        }
      }else{
        emit(ProfileFailure(message: res.message));
      }
    }catch(e){
      emit(ProfileFailure(message: e.toString()));
    }

  }
  void _profileLoad(ProfileLoad event, Emitter<ProfileState> emit) async{
    emit(ProfileInProgress());
    try{
      ResponseModel res = await repository.getDanhSachTimKiem();
      if(res.status == 1){
        emit(ProfileSuccess(list: res.data));

      }else{
        emit(ProfileFailure(message: res.message));
      }
    }catch(e){
      emit(ProfileFailure(message: e.toString()));
    }
  }

}