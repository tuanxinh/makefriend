

class TruongModel{
  int id;
  String tenTruong;

  TruongModel({required this.id, required this.tenTruong});
  factory TruongModel.fromJson(Map<String, dynamic> json) {
    return TruongModel(
      id: json['id'],
      tenTruong: json['tenTruong'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTruong': tenTruong,
    };
  }

  static List<TruongModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TruongModel.fromJson(json)).toList();
  }
}
class NganhModel {
  int id;
  String tenNganh;
  int truongHocId;

  NganhModel({required this.id, required this.tenNganh, required this.truongHocId});

  factory NganhModel.fromJson(Map<String, dynamic> json) {
    return NganhModel(
      id: json['id'],
      tenNganh: json['tenNganh'] ?? '',
      truongHocId: json['truongHocId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNganh': tenNganh,
      'truongHocId': truongHocId
    };
  }

  static List<NganhModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NganhModel.fromJson(json)).toList();
  }
}
class LopHocModel {
  int id;
  String tenLop;
  int nganhHocID;
  LopHocModel({required this.id, required this.tenLop, required this.nganhHocID});

  factory LopHocModel.fromJson(Map<String, dynamic> json) {
    return LopHocModel(
      id: json['id'],
      tenLop: json['tenLop'] ?? '',
      nganhHocID: json['nganhHocID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenLop': tenLop,
      'nganhHocID': nganhHocID
    };
  }

  static List<NganhModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NganhModel.fromJson(json)).toList();
  }
}

class DanhSachModel {
  final List<NganhModel> nganh;
  final List<LopHocModel> lop;
  final List<TruongModel> truong;

  DanhSachModel({
    required this.nganh,
    required this.lop,
    required this.truong,
  });

  factory DanhSachModel.fromJson(Map<String, dynamic> json) {
    final nganhList = (json['nganh'] as List?) ?? [];
    final lopList = (json['lop'] as List?) ?? [];
    final truongList = (json['truong'] as List?) ?? [];

    return DanhSachModel(
      nganh: nganhList.map((e) => NganhModel.fromJson(e)).toList(),
      lop: lopList.map((e) => LopHocModel.fromJson(e)).toList(),
      truong: truongList.map((e) => TruongModel.fromJson(e)).toList(),
    );
  }
}

