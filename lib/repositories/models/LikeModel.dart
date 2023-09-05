import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';

Future<void> likeModelAsync(String id) async {
  final connectionString = "${AppSettings.baseUri}api/1.0/model/$id";
  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  Response<dynamic>? response;
  response = await dio.put(connectionString);
}