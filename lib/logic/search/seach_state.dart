

import 'package:makefriend/data/model/timkiemModel.dart';
import 'package:makefriend/data/model/user.dart';

class SearchState {}

class SearchInitial extends SearchState{}

class SearchInProgress extends SearchState{
}

class SearchFailure extends SearchState {
  String message;
  SearchFailure({required this.message});
}

class SearchSuccess extends SearchState{
  List<User> list;
  SearchSuccess({required this.list});
}

class NotificationSearch extends SearchState {
  String message;
  NotificationSearch({required this.message});
}

class KetBanFetchSuccess extends SearchState{
  List<User> list;
  KetBanFetchSuccess({required this.list});
}

class GetTruongProgress extends SearchState{}
class GetTruongSuccess extends SearchState{
  DanhSachModel list;
  GetTruongSuccess({required this.list});
}
class GetTruongFailure extends SearchState{
  String text;
  GetTruongFailure({required this.text});

}
