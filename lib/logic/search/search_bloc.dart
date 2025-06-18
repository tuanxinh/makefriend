


import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/model/user.dart';
import 'package:makefriend/data/repository/search_repository.dart';
import 'package:makefriend/logic/search/seach_state.dart';
import 'package:makefriend/logic/search/search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{
  SearchBloc({required this.repository}): super(SearchInitial()){
    on<SearchStart>(_searchStart);
    on<KetBan>(_ketban);
    on<FetchListKetBan>(_fetchListKetBan);
    on<AceptKetBan>(_aceptketban);
    on<GetTruong>(_getTruong);
    on<XoaKetBan>(_xoaketban);
  }
  final SearchRepository repository;
  void _getTruong(GetTruong event, Emitter<SearchState> emit) async{
    emit(GetTruongProgress());
    try{
      ResponseModel res = await repository.getDanhSachTimKiem();
      if(res.status == 1){
        emit(GetTruongSuccess(list: res.data));

      }else{
        emit(GetTruongFailure(text: res.message));
      }


    }catch(e){
      emit(GetTruongFailure(text: e.toString()));
    }
  }
  void _xoaketban(XoaKetBan event, Emitter<SearchState> emit) async{
    try{
      ResponseModel res = await repository.xoaKetBan(event.guinhan, event.nguoigui);
      print("${res.status} + ${res.message}");
      emit(NotificationSearch(message: res.message));

    }catch(e){
      emit(SearchFailure(message: e.toString()));
    }
  }
  void _aceptketban(AceptKetBan event, Emitter<SearchState> emit) async{
    //emit(SearchInProgress());
    try{
      ResponseModel res = await repository.aceptketbnan(event.guinhan, event.nguoigui);
      emit(NotificationSearch(message: res.message));

    }catch(e){
      emit(SearchFailure(message: e.toString()));
    }
  }
  void _fetchListKetBan(FetchListKetBan event, Emitter<SearchState> emit) async{
    emit(SearchInProgress());
    try{

      ResponseModel res = await repository.fetchListKetBan(event.id);

      print(res.data.toString());
      // Ép kiểu thủ công
      List<User> users = (res.data as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(SearchSuccess(list: users));
    }catch(e){
      emit(SearchFailure(message: e.toString()));
    }
  }
  void _searchStart(SearchStart event, Emitter<SearchState> emit) async{
    emit(SearchInProgress());
    try{

      ResponseModel res = await repository.findUsers(event.type, event.input);

      print(res.data.toString());
      // Ép kiểu thủ công
      List<User> users = (res.data as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(SearchSuccess(list: users));
    }catch(e){
      emit(SearchFailure(message: e.toString()));
    }

  }

  void _ketban(KetBan event, Emitter<SearchState> emit) async{
    try{

      ResponseModel res = await repository.ketBan(event.nguoigui, event.guinhan);
      emit(NotificationSearch(message: res.message));

    }catch(e){
      emit(NotificationSearch(message: e.toString()));
    }

  }
}