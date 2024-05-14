import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import 'auth_service.dart';

class ApiService{
  static String baseUrl = 'https://ili-art.space/api/2.0/';
  static final authService = Injector.appInstance.get<AuthService>();

  static var _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {"Authorization": "Bearer ${authService.accessToken}"},
    validateStatus: (code) => code! <= 500,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
  );

  static Future<void> restartService() async =>
      _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: {"Authorization": "Bearer ${authService.accessToken}"},
        validateStatus: (code) => code! <= 500,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
      );

  static Future<Response?> sendRequest({
    required String request,
    RequestMethod method = RequestMethod.get,
    Object? data = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
  }) async {
    try{
      Response? response = await _dio.request(
        request,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method.name,
          headers: headers,
        ),
      );
      if (response.statusCode == 401) {
        await authService.loginNoName();
        response = await sendRequest(
          request: request,
          method: method,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        );
      }
      debugPrint('code: ${response?.statusCode} - message: ${response?.data}');
      return response;
    } catch (ex) {
      debugPrint('Exception on request: $ex');
    }
    return null;
  }
}

enum RequestMethod{
  get,
  post,
  delete,
  put,
  patch,
}