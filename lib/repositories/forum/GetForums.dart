import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';


Future<Forums> getForumsAsync(int count, int skip) async {
  final connectionString = "${AppSettings.baseUri}api/1.0/forum/list?Count=$count&Skiped=$skip";
  Dio dio = Dio();

  var response = await dio.get(connectionString);
  if(response.statusCode != 200) {
    return Forums();
  }

  return Forums.fromJson(response.data);
}