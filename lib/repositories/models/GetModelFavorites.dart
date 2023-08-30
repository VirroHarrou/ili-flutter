import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/model.dart';

Future<Favorites?> getModelFavoritesAsync(String? search) async{
  String connectionString;
  if(search == null || search == '') {
    connectionString = "${AppSettings.baseUri}api/1.0/model/favorites";
  } else {
    connectionString = "${AppSettings.baseUri}api/1.0/model/favorites/$search";
  }

  Dio dio = Dio();

  dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
  Response<dynamic>? response;
  try{
    response = await dio.get(connectionString);
  } catch (ex) {
    return null;
  }

  return Favorites.fromJson(response.data);
}