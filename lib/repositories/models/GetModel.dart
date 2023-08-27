import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/model.dart';

Future<Model?> getModelAsync(int? code, String? id) async {
  String connectionString;
  if (id != null) {
    connectionString = "${AppSettings.baseUri}api/1.0/model/id=$id";
  } else if (code != null) {
    connectionString = "${AppSettings.baseUri}api/1.0/model/code=$code";
  } else {
    return null;
  }
  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  Response<dynamic>? response;
  try{
    response = await dio.get(connectionString);
  } catch (ex) {
    return null;
  }


  return Model.fromJson(response.data);
}