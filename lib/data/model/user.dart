

class User {
  final int maSinhVien;
  final String hoTen;
  final String email;
  final String? anhDaiDien;
  final String? kyNang;
  final String? soThich;
  final String matKhau;
  final String? ngaySinh;
  final String? gioiTinh;
  final String? truong;
  final String? nganhHoc;
  final String? lop;
  final String? moTa;
  final String? ngayTao;
  final int? quyen;

  User({
    required this.maSinhVien,
    required this.hoTen,
    required this.email,
    this.anhDaiDien,
    this.kyNang,
    this.soThich,
    required this.matKhau,
    this.ngaySinh,
    this.gioiTinh,
    this.truong,
    this.nganhHoc,
    this.lop,
    this.moTa,
    this.ngayTao,
    this.quyen,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      maSinhVien: json['maSinhVien'] ?? 0,
      hoTen: json['hoTen'] ?? '',
      email: json['email'] ?? '',
      anhDaiDien: json['anhDaiDien'] ?? '',
      kyNang: json['kyNang'] ?? '',
      soThich: json['soThich'] ?? '',
      matKhau: json['matKhau'] ?? '',
      ngaySinh: json['ngaySinh'] ?? '',
      gioiTinh: json['gioiTinh'] ?? '',
      truong: json['tenTruong'] ?? '',
      nganhHoc: json['tenNganh'] ?? '',
      lop: json['tenLop'] ?? '',
      moTa: json['moTa'] ?? '',
      ngayTao: json['ngayTao'] ?? '',
      quyen: json['quyen'] ?? 0
    );
  }

  factory User.fromJson2(Map<String, dynamic> json) {
    return User(
      maSinhVien: json['maSinhVien'] is int
          ? json['maSinhVien']
          : int.tryParse(json['maSinhVien'].toString()) ?? 0,
      hoTen: json['hoTen'] as String? ?? '',
      email: json['email'] as String? ?? '',
      anhDaiDien: json['anhDaiDien'] as String?,
      kyNang: json['kyNang'] as String?,
      soThich: json['soThich'] as String?,
      matKhau: json['matKhau'] as String? ?? '', // Giả sử mặc định nếu không có
      ngaySinh: json['ngaySinh'] as String?,
      gioiTinh: json['gioiTinh'] as String?,
      truong: json['truong'] as String?, // Sửa từ tenTruong thành truong
      nganhHoc: json['nganhHoc'] as String?, // Sửa từ tenNganh thành nganhHoc
      lop: json['lop'] as String?, // Sửa từ tenLop thành lop
      moTa: json['moTa'] as String?,
      ngayTao: json['ngayTao'] as String?,
      quyen: json['quyen'] is int ? json['quyen'] : int.tryParse(json['quyen'].toString()) ?? 0,
    );
  }
  static List<User> JsonToList(List<dynamic> json){
    return json.map((json) => User.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'masinhvien': maSinhVien,
      'hoten': hoTen,
      'email': email,
      'anhdaidien': anhDaiDien,
      'kynang': kyNang,
      'sothich': soThich,
      'matkhau': matKhau,
      'ngaysinh': ngaySinh,
      'gioitinh': gioiTinh,
      'truong': truong,
      'nganhhoc': nganhHoc,
      'lop': lop,
      'mota': moTa,
      'ngaytao': ngayTao,
      'quyen': quyen,
    };
  }
}
