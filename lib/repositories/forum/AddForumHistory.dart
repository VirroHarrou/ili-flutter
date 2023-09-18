import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';

Future<void> addForumHistoryAsync(String id) async {
  final connectionString = "${AppSettings.baseUri}api/1.0/forum/$id";
  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  var response = await dio.post(connectionString);

  return;
}