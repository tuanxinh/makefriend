class Ranking {
  final int userId;
  final String hoTen;
  final double diemTrungBinh;
  final int soLuotDanhGia;
  final List<String> danhSachNhanXet;

  Ranking({
    required this.userId,
    required this.hoTen,
    required this.diemTrungBinh,
    required this.soLuotDanhGia,
    required this.danhSachNhanXet,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      userId: json['userId'],
      hoTen: json['hoTen'],
      diemTrungBinh: (json['diemTrungBinh'] as num).toDouble(),
      soLuotDanhGia: json['soLuotDanhGia'],
      danhSachNhanXet: List<String>.from(json['danhSachNhanXet']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'hoTen': hoTen,
      'diemTrungBinh': diemTrungBinh,
      'soLuotDanhGia': soLuotDanhGia,
      'danhSachNhanXet': danhSachNhanXet,
    };
  }
}


