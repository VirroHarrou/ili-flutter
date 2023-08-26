import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';

import '../models/models.dart';

Future<Forums> getForumsSearchAsync(String query) async {
  final connectionString = "${AppSettings.baseUri}api/1.0/forum/list/$query";
  Dio dio = Dio();

  var response = await dio.get(connectionString);
  if(response.statusCode != 200) {
    return Forums();
  }

  return Forums.fromJson(response.data);
}