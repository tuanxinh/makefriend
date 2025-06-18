


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/auth_repository.dart';
import 'package:makefriend/logic/auth/auth_event.dart';
import 'package:makefriend/logic/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc({required this.repository}) : super(AuthInitial()){
    on<AuthLogin>(_login);
    on<AuthRegister>(_register);
  }
  final AuthRepository repository;
  void _register(AuthRegister event, Emitter<AuthState> emit) async{

    emit(AuthInProgress());
    try{

      ResponseModel res = await repository.register(event.email, event.password, event.hoten);
      if(res.status == 1){
        myUser = User.fromJson(res.data);
        emit(AuthRegisterSuccess(message: res.message));
      }
      else emit(AuthFailure(message: res.message));

    }catch(e){
      emit(AuthFailure(message: e.toString()));
    }

  }
  void _login(AuthLogin event, Emitter<AuthState> emit) async{

    emit(AuthInProgress());
    try{

      ResponseModel res = await repository.login(event.email, event.password);
      if(res.status == 1){
        myUser = User.fromJson(res.data);
        emit(AuthSuccess());
      }
      else emit(AuthFailure(message: res.message));

    }catch(e){
      emit(AuthFailure(message: e.toString()));
    }

  }
}