import 'dart:convert';

import 'package:makefriend/core/config.dart';
import 'package:http/http.dart' as http;
import 'package:makefriend/data/model/ResponseModel.dart';
class ApiService{
  Future<bool> checkInternetConnection() async {
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    //   return false;
    // }
    // return await InternetConnectionChecker.instance.hasConnection;
    return true;
  }
  Future<dynamic> get2(String path) async {
    final uri = Uri.parse('${API_SERVER}$path');
    final response = await http.get(uri, headers: {'Accept': 'application/json'});
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('GET $path failed with status: ${response.statusCode}');
    }
  }

  Future<T> get<T>({required String urlEndpoint,
    required T Function(dynamic) fromJson,

    Map<String,String>? headers}) async{
    try {
      headers = headers ?? {};

      Uri url = Uri.parse("$API_SERVER$urlEndpoint");
      final defaultHeader = {
        "Content-Type" : "application/json",
        ...?headers,
      };
      final response = await http.get(url, headers: defaultHeader);

      return handleResponse<T>(response, fromJson);
    }catch(e){
      throw Exception("Error Get Method: $e");
    }
  }
  Future<T> post<T>({required String urlEndpoint,
    required T Function(dynamic) fromJson,
    Map<String, String>? headers,

    required Object data
  }) async{

    try{
      Uri url = Uri.parse("$API_SERVER$urlEndpoint");
      final defaultHeaders = {
        "Content-Type" : "application/json",
        ...?headers
      };
      final response = await http.post(url, headers: defaultHeaders, body: jsonEncode(data));



      return handleResponse<T>(response, fromJson);
    }catch(e){
      throw Exception("Error Post Method: $e ");
    }
  }
  Future<T> patch<T>({required String urlEndpoint,
    required T Function(dynamic) fromJson,
    Map<String, String>? headers,

    required Object data
  }) async{
    try{
      Uri url = Uri.parse("$API_SERVER$urlEndpoint");
      final defaultHeaders = {
        "Content-Type" : "application/json",
        ...?headers
      };
      final response = await http.patch(url, headers: defaultHeaders, body: jsonEncode(data));



      return handleResponse<T>(response, fromJson);
    }catch(e){
      throw Exception("Error Post Method: $e");
    }
  }
  Future<T> put<T>({required String urlEndpoint,
    required T Function(dynamic) fromJson,
    Map<String, String>? headers,

    required Object data
  }) async{
    try{
      Uri url = Uri.parse("$API_SERVER$urlEndpoint");
      final defaultHeaders = {
        "Content-Type" : "application/json",
        ...?headers
      };
      final response = await http.put(url, headers: defaultHeaders, body: jsonEncode(data));



      return handleResponse<T>(response, fromJson);
    }catch(e){
      throw Exception("Error Post Method: $e");
    }
  }
  Future<T> delete<T>({required String urlEndpoint,
    required T Function(dynamic) fromJson,

    Map<String,String>? headers}) async{
    try {
      Uri url = Uri.parse("$API_SERVER$urlEndpoint");
      final defaultHeader = {
        "Content-Type" : "application/json",
        ...?headers,
      };
      final response = await http.delete(url, headers: defaultHeader);

      return handleResponse<T>(response, fromJson);
    }catch(e){
      throw Exception("Error delete Method: $e");
    }
  }
  T handleResponse<T>(http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fromJson(jsonDecode(response.body));
    } else {
      String errorMessage = "An error occurred";
      try {

        var errorResponse = jsonDecode(response.body);
        print("errorResponse: " + response.body);
        if (errorResponse['Message'] != null) {
          errorMessage = errorResponse['Message'];
        }
      } catch (e) {
        errorMessage = "Failed to parse error message";
      }
      return ResponseModel<T>(status: response.statusCode, message: errorMessage, data: null) as T;
    }
  }
}