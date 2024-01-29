import 'package:eproject_watchub/data/datasource/remote/dio/dio_client.dart';
import 'package:eproject_watchub/data/datasource/remote/exception/api_error_handler.dart';
import 'package:eproject_watchub/data/model/response/base/api_response.dart';
import 'package:eproject_watchub/utill/app_constants.dart';


class WishListRepo {
  final DioClient? dioClient;

  WishListRepo({required this.dioClient});

  Future<ApiResponse> getWishList() async {
    try {
      final response = await dioClient!.get(AppConstants.wishListGetUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addWishList(List<int?> productID) async {
    try {
      final response = await dioClient!.post(AppConstants.wishListGetUri, data: {'product_ids' : productID});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWishList(List<int?> productID) async {
    try {
      final response = await dioClient!.delete(AppConstants.wishListGetUri, data: {'product_ids' : productID, '_method':'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
