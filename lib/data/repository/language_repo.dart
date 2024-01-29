import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/datasource/remote/dio/dio_client.dart';
import 'package:eproject_watchub/data/datasource/remote/exception/api_error_handler.dart';
import 'package:eproject_watchub/data/model/response/base/api_response.dart';
import 'package:eproject_watchub/data/model/response/language_model.dart';
import 'package:eproject_watchub/utill/app_constants.dart';

class LanguageRepo {
  final DioClient? dioClient;

  LanguageRepo({required this.dioClient});

  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }

  Future<ApiResponse> changeLanguageApi({required String? languageCode}) async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.changeLanguage,
        data: {'language_code' : languageCode},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
