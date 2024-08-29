import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:funxtion/funxtion_sdk.dart';

class NetworkHelper {
  late CacheStore? dioCacheManager;
  late Dio dio;

  NetworkHelper() {
    dio = Dio(BaseOptions(
      baseUrl: "https://api-staging.funxtion.com/v3/",
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${BearerToken.getToken}",
        if (AppLanguage.getLanguageCode != null)
          "Accept-Language": AppLanguage.getLanguageCode,
      },
    ));
  }
  Future<Response> searchContentRequest(
      {required Map<String, dynamic> data}) async {
    Map<String, dynamic> newData = {};
    newData.addAll(data);
    if (ContentPackage.getContentPackageId != null) {
      newData.addAll({"content_package": ContentPackage.getContentPackageId});
    }

    return await dio.post(
      ConstantApis.searchContentApi,
      data: newData,
    );
  }

  Future<Response> getListOfExerciseRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }

    return await dio.get(ConstantApis.listExerciseApi,
        queryParameters: newParams);
  }

  Future<Response> getExerciseByIdRequest({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getExerciseApi + id,
    );
  }

  Future<Response> getListOfWorkoutRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(
      ConstantApis.listWorkoutApi,
      queryParameters: newParams,
    );
  }

  Future<Response> getWorkoutByIdRequest({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getWorkoutApi + id,
    );
  }

  Future<Response> getWorkoutFilterRequest() async {
    return await dio.get(ConstantApis.getWorkoutFilterApi, queryParameters: {
      if (ContentPackage.getContentPackageId != null)
        "content_package": ContentPackage.getContentPackageId
    });
  }

  Future<Response> getListOfTrainingPlanRequest({
    Map<String, dynamic>? queryParameters,
  }) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(
      ConstantApis.listTrainingPlanApi,
      queryParameters: newParams,
    );
  }

  Future<Response> getTrainingPlanFilterRequest() async {
    return await dio
        .get(ConstantApis.getTrainingPlanFilterApi, queryParameters: {
      if (ContentPackage.getContentPackageId != null)
        "content_package": ContentPackage.getContentPackageId
    });
  }

  Future<Response> getTrainingPlanByIdRequest({required String id}) async {
    return await dio.get(
      ConstantApis.getTrainingPlanApi + id,
    );
  }

  Future<Response> getListOfEquipmentRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listEquipmentApi,
        queryParameters: newParams);
  }

  Future<Response> getListOfEquipmentBrandRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listEquipmentBrandApi,
        queryParameters: newParams);
  }

  Future<Response> getEquipmentByIdReques({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getEquipmentApi + id,
    );
  }

  Future<Response> getListOfFitnessGoalRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listFitnessGoalApi,
        queryParameters: newParams);
  }

  Future<Response> getFitnessGoalByIdRequest({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getFitnessGoalApi + id,
    );
  }

  Future<Response> getListOfInstructorsRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listInstructorApi,
        queryParameters: newParams);
  }

  Future<Response> getInstructorByIdRequest({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getInstructorApi + id,
    );
  }

  Future<Response> getListOnDemandRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(
      ConstantApis.listOnDemandApi,
      queryParameters: newParams,
    );
  }

  Future<Response> getOnDemandFilterRequest() async {
    return await dio.get(ConstantApis.getOnDemandFilterApi, queryParameters: {
      if (ContentPackage.getContentPackageId != null)
        "content_package": ContentPackage.getContentPackageId
    });
  }

  Future<Response> getOnDemandByIdRequest({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getOnDemandApi + id,
    );
  }

  Future<Response> getListOfContentProviderRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listContentProvidersApi,
        queryParameters: newParams);
  }

  Future<Response> getListOfContentCategoryRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listContentCategoryApi,
        queryParameters: newParams);
  }

  Future<Response> getListOnDemandCategoriesRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listOnDemandCategoryApi,
        queryParameters: newParams);
  }

  Future<Response> getListOfMuscleGroupRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listMuscleGroupApi,
        queryParameters: newParams);
  }

  Future<Response> getFitnessActivitiesTypeRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.getFitnessActivitiesTypeApi,
        queryParameters: newParams);
  }

  Future<Response> getFitnessActivityTypeByIdrequest({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getFitnessActivityTypeApi + id,
    );
  }

  Future<Response> getBodyPartsRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.getBodyPartsApi,
        queryParameters: newParams);
  }

  Future<Response> getABodyPartById({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getABodyPartsApi + id,
    );
  }

  Future<Response> getListOfContentPackageRequest(
      {Map<String, dynamic>? queryParameters}) async {
    Map<String, dynamic>? newParams = {};
    newParams.addAll(queryParameters ?? {});
    if (ContentPackage.getContentPackageId != null) {
      newParams.addAll({"content_package": ContentPackage.getContentPackageId});
    }
    return await dio.get(ConstantApis.listContentPackagesApi,
        queryParameters: newParams);
  }

  Future<Response> getContentPackageById({
    required String id,
  }) async {
    return await dio.get(
      ConstantApis.getContentPackagesApi + id,
    );
  }

  Future<Response> getListContentPackageItemRequest({
    required String id,
  }) async {
    return await dio.get(
      "${ConstantApis.listContentPackageItemApi}$id/items",
    );
  }
}
