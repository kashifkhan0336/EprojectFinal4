import 'package:dio/dio.dart';
import 'package:eproject_watchub/data/datasource/remote/dio/dio_client.dart';
import 'package:eproject_watchub/data/datasource/remote/exception/api_error_handler.dart';
import 'package:eproject_watchub/data/model/response/base/api_response.dart';
import 'package:eproject_watchub/utill/app_constants.dart';

class CategoryRepo {
  final DioClient? dioClient;
  CategoryRepo({required this.dioClient});

  Future<ApiResponse> getCategoryList(String? languageCode) async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri,
          options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList(String parentID, String languageCode) async {
    try {
      final response = await dioClient!.get('${AppConstants.subCategoryUri}$parentID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryProductList(String categoryID, String languageCode) async {
    try {
      final response = await dioClient!.get('${AppConstants.categoryProductUri}$categoryID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}