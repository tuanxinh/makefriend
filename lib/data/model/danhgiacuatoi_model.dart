class DanhGiaCuaToi {
  final String hoTen;
  final String nhanXet;
  final int tieuchi1;
  final int tieuchi2;
  final int tieuchi3;
  final int tieuchi4;
  final int tieuchi5;

  DanhGiaCuaToi({
    required this.hoTen,
    required this.nhanXet,
    required this.tieuchi1,
    required this.tieuchi2,
    required this.tieuchi3,
    required this.tieuchi4,
    required this.tieuchi5,
  });

  factory DanhGiaCuaToi.fromJson(Map<String, dynamic> json) {
    return DanhGiaCuaToi(
      hoTen: json['hoTenNguoiDanhGia'] ?? "",
      nhanXet: json['nhanXet']?? "",
      tieuchi1: json['tieuchi1'] ?? 0,
      tieuchi2: json['tieuchi2']?? 0,
      tieuchi3: json['tieuchi3']?? 0,
      tieuchi4: json['tieuchi4']?? 0,
      tieuchi5: json['tieuchi5']?? 0,
    );
  }

}
