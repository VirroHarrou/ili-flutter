import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/model.dart';

Future<ModelList?> getModelListAsync() async{
  String connectionString = "${AppSettings.baseUri}api/1.0/model/list";

  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  Response<dynamic>? response;
  try{
    response = await dio.get(connectionString);
  } catch (ex) {
    return null;
  }

  return ModelList.fromJson(response.data);
}