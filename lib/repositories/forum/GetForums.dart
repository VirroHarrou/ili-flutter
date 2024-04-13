import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';


Future<Forums> getForumsAsync(int count, int skip) async {
  final connectionString = "${AppSettings.baseUri}api/2.0/platform/list?Count=$count&Skiped=$skip";
  Dio dio = Dio();

  var response = await dio.get(connectionString);
  print(response);
  if(response.statusCode != 200) {
    return Forums();
  }

  return Forums.fromJson(response.data);
}