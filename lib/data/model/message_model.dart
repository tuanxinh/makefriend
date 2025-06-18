class Message {
  final int guiId;
  final int nhanId;
  final String noiDung;

  Message({required this.guiId, required this.nhanId, required this.noiDung});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      guiId: json['guiId'],
      nhanId: json['nhanId'],
      noiDung: json['noiDung'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guiId': guiId,
      'nhanId': nhanId,
      'noiDung': noiDung,
    };
  }
}