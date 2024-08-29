import 'package:dio/dio.dart';

class ResponseConstants {
    static Map<String, dynamic> convertResponse(Response<dynamic> response) {
    Map<String, dynamic> data = response.data;
    return data;
  }

  static List<Map<String, dynamic>> convertResponseList(
      Response<dynamic> response) {
    List<Map<String, dynamic>> data =
        List.from(response.data['data'].map((e) => e));
    return data;
  }
    static List<Map<String, dynamic>> convertResponseFilterList(
      Response<dynamic> response) {
    List<Map<String, dynamic>> data =
        List.from(response.data.map((e) => e));
    return data;
  }
}