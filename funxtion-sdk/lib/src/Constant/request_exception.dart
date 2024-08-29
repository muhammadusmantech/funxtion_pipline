import 'package:dio/dio.dart';

class RequestException {
  dynamic error;
  String message;
  RequestOptions requestOptions;
  Response<dynamic>? response;
  RequestException(
      {required this.error,
      required this.message,
      required this.requestOptions,
      required this.response});
}

RequestException convertDioErrorToRequestException(DioException dioError) {
  return RequestException(
    error: dioError.error,
    message: dioError.message.toString(),
    requestOptions: dioError.requestOptions,
    response: dioError.response,
  );
}
