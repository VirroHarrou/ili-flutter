import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';


Future<Forums?> getForumHistoryAsync() async {
  final connectionString = "${AppSettings.baseUri}api/2.0/platform/history";
  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  var response = await dio.get(connectionString);

  return Forums.fromJson(response.data);
}