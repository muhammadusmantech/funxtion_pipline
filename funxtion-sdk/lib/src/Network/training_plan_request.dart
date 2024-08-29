import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import '../../funxtion_sdk.dart';

class TrainingPlanRequest {
  static Future<List<Map<String, dynamic>>?> listOfTrainingPlan(
      {bool forceRefresh = true,
      Duration maxStale = const Duration(days: 1),
      Map<String, dynamic>? queryParameters}) async {
    NetworkHelper networkHelper = NetworkHelper();
    Response<dynamic> response;
    bool? checkInternet;
    await Connectivity().checkConnectivity().then((value) {
      if (value.first == ConnectivityResult.none) {
        checkInternet = false;
      } else {
        checkInternet = true;
      }
    });
    try {
      if (kIsWeb) {
        _addDioCacheInterceptor(html.window.location.pathname ?? "",
            networkHelper, maxStale, forceRefresh, checkInternet);
        response = await networkHelper.getListOfTrainingPlanRequest(
            queryParameters: queryParameters);
      } else {
        await getTemporaryDirectory().then((value) async {
          _addDioCacheInterceptor(
              value.path, networkHelper, maxStale, forceRefresh, checkInternet);
        });
        response = await networkHelper.getListOfTrainingPlanRequest(
            queryParameters: queryParameters);
      }

      if (response.statusCode == 200 || response.statusCode == 304) {
        return await compute(ResponseConstants.convertResponseList, response);
      }
    } on DioException catch (e) {
      throw convertDioErrorToRequestException(e);
    }

    return null;
  }

  static Future<Map<String, dynamic>?> trainingPlanById(
      {required String id,
      bool forceRefresh = true,
      Duration maxStale = const Duration(days: 1)}) async {
    NetworkHelper networkHelper = NetworkHelper();
    Response<dynamic> response;
    bool? checkInternet;
    await Connectivity().checkConnectivity().then((value) {
      if (value.first == ConnectivityResult.none) {
        checkInternet = false;
      } else {
        checkInternet = true;
      }
    });
    try {
      if (kIsWeb) {
        _addDioCacheInterceptor(html.window.location.pathname ?? "",
            networkHelper, maxStale, forceRefresh, checkInternet);
        response = await networkHelper.getTrainingPlanByIdRequest(
          id: id,
        );
      } else {
        await getTemporaryDirectory().then((value) async {
          _addDioCacheInterceptor(
              value.path, networkHelper, maxStale, forceRefresh, checkInternet);
        });
        response = await networkHelper.getTrainingPlanByIdRequest(
          id: id,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 304) {
        return await compute(ResponseConstants.convertResponse, response);
      }
    } on DioException catch (e) {
      throw convertDioErrorToRequestException(e);
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>?> trainingPlanFilters({
    bool forceRefresh = true,
    Duration maxStale = const Duration(days: 1),
  }) async {
    NetworkHelper networkHelper = NetworkHelper();
    Response<dynamic>? response;
    bool? checkInternet;
    await Connectivity().checkConnectivity().then((value) {
      if (value.first == ConnectivityResult.none) {
        checkInternet = false;
      } else {
        checkInternet = true;
      }
    });
    try {
      if (kIsWeb) {
        _addDioCacheInterceptor(html.window.location.pathname ?? "",
            networkHelper, maxStale, forceRefresh, checkInternet);
        response = await networkHelper.getTrainingPlanFilterRequest();
      } else {
        await getTemporaryDirectory().then((value) async {
          _addDioCacheInterceptor(
              value.path, networkHelper, maxStale, forceRefresh, checkInternet);
        });
        response = await networkHelper.getTrainingPlanFilterRequest();
      }

      if (response.statusCode == 200 || response.statusCode == 304) {
        return await compute(
            ResponseConstants.convertResponseFilterList, response);
      }
      return null;
    } on DioException catch (e) {
      throw convertDioErrorToRequestException(e);
    }
  }

  static void _addDioCacheInterceptor(
    String path,
    NetworkHelper networkHelper,
    Duration maxStale,
    bool forceRefresh,
    bool? checkInternet,
  ) async {
    networkHelper.dio.interceptors.add(DioCacheInterceptor(
        options: CacheOptions(
            store: HiveCacheStore(path),
            allowPostMethod: true,
            maxStale: maxStale,
            priority: CachePriority.high,
            policy: checkInternet == true && forceRefresh == true
                ? CachePolicy.refreshForceCache
                : CachePolicy.forceCache)));
  }
}
