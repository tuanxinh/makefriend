
import 'package:makefriend/data/model/timkiemModel.dart';

class TimkiemState {}
class TimKiemInitial extends TimkiemState{}
class TimKiemProgress extends TimkiemState{}
class TimKiemSuccess extends TimkiemState{
  DanhSachModel list;
  TimKiemSuccess({required this.list});
}
class TimKiemFailure extends TimkiemState{
  String text;
  TimKiemFailure({required this.text});

}
