


class ResponseModel<T>{
  int status;
  String message;
  T? data;

  ResponseModel({required this.status, required this.message, required this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json){
    return ResponseModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] as T?,
    );
  }
  factory ResponseModel.fromJson2(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonData,
      ) {
    return ResponseModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] != null ? fromJsonData(json["data"]) : null,
    );
  }
}

class FileUploadResponse {
  final String message;
  final String fileName;
  final String downloadLink;

  FileUploadResponse({
    required this.message,
    required this.fileName,
    required this.downloadLink,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      message: json['message']?? '',
      fileName: json['fileName']?? '',
      downloadLink: json['downloadUrl']?? '',
    );
  }
}