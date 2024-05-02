import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';

import '../views/forum.dart';

Future<Forum?> getForumDetailAsync(String id) async {
  final connectionString = "${AppSettings.baseUri}api/2.0/platform/$id";
  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  var response = await dio.get(connectionString);

  return Forum.fromJson(response.data);
}