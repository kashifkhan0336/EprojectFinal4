import 'package:eproject_watchub/data/datasource/remote/dio/dio_client.dart';
import 'package:eproject_watchub/data/datasource/remote/exception/api_error_handler.dart';
import 'package:eproject_watchub/data/model/response/base/api_response.dart';
import 'package:eproject_watchub/utill/app_constants.dart';
class BannerRepo {
  final DioClient? dioClient;
  BannerRepo({required this.dioClient});

  Future<ApiResponse> getBannerList() async {
    try {
      final response = await dioClient!.get(AppConstants.bannerUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID) async {
    try {
      final response = await dioClient!.get('${AppConstants.productDetailsUri}$productID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}