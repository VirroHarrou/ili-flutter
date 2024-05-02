import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';


Future<Forums> getForumsSearchAsync(String query) async {
  final connectionString = "${AppSettings.baseUri}api/2.0/platform/list/$query";
  Dio dio = Dio();

  var response = await dio.get(connectionString);
  if(response.statusCode != 200) {
    return Forums();
  }

  return Forums.fromJson(response.data);
}