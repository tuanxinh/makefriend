

class SearchEvent{}

class SearchStart extends SearchEvent{
  String type;
  String input;
  SearchStart({required this.type, required this.input});
}
class KetBan extends SearchEvent{
  int nguoigui;
  int guinhan;
  KetBan({required this.guinhan,required this.nguoigui});
}
class AceptKetBan extends SearchEvent{
  int nguoigui;
  int guinhan;
  AceptKetBan({required this.guinhan,required this.nguoigui});
}

class XoaKetBan extends SearchEvent{
  int nguoigui;
  int guinhan;
  XoaKetBan({required this.guinhan,required this.nguoigui});
}
class FetchListKetBan extends SearchEvent{
  int id;
  FetchListKetBan({required this.id});
}

class GetTruong extends SearchEvent{
}
class GetNganh extends SearchEvent{
  int idTruong;
  GetNganh({required this.idTruong});
}
class GetLophoc extends SearchEvent{
  int idNganh;
  GetLophoc({required this.idNganh});
}
