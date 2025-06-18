

class DanhGiaEvent {}

class FetchDanhSach extends DanhGiaEvent{}

class DanhGiaNe extends DanhGiaEvent{
  int nguoiDanhGia;
  int nguoiDuocDanhGia;
  int tieuchi1;
  int tieuchi2;
  int tieuchi3;
  int tieuchi4;
  int tieuchi5;
  String nhanXet;
  DanhGiaNe({required this.nguoiDanhGia, required this.nguoiDuocDanhGia,
  required this.tieuchi1, required this.tieuchi2, required this.tieuchi3, required this.tieuchi4, required this.tieuchi5,
  required this.nhanXet});



}
class FetchMyDanhGia extends DanhGiaEvent{}

class XoaBanBe extends DanhGiaEvent{
  int id;
  XoaBanBe({required this.id});
}

