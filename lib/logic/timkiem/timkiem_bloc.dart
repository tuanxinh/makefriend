import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/data/model/ResponseModel.dart';
import 'package:makefriend/data/repository/search_repository.dart';
import 'package:makefriend/logic/timkiem/timkiem_event.dart';
import 'package:makefriend/logic/timkiem/timkiem_state.dart';

class TimkiemBloc extends Bloc<TimKiemEvent, TimkiemState> {
  TimkiemBloc({required this.repository}) : super((TimKiemInitial())) {
    on<TimKiemTruong>(_getTruong);
  }

  final SearchRepository repository;

  void _getTruong(TimKiemTruong event, Emitter<TimkiemState> emit) async {
    emit(TimKiemProgress());
    try {
      ResponseModel res = await repository.getDanhSachTimKiem();
      if (res.status == 1) {
        emit(TimKiemSuccess(list: res.data));
      } else {
        emit(TimKiemFailure(text: res.message));
      }
    } catch (e) {
      emit(TimKiemFailure(text: e.toString()));
    }
  }
}