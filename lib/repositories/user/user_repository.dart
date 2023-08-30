import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';

Future<Map<ResponseType,String>> tryLoginAsync(String email, String password) async{
  final connectionString = "${AppSettings.baseUri}api/1.0/auth/login";
  Dio dio = Dio();
  var response = await dio.post(connectionString,
      data: {"email": email,
        "password": password});
  if(response.statusCode == 200) {
    return {ResponseType.success : response.data};
  } else if (response.statusCode == 400) {
    Map<String, dynamic> json = response.data;
    String property = json['PropertyName'];
    if (property == 'Email') {
      return {ResponseType.bad: 'email incorrect'};
    }
    return {ResponseType.bad: 'bad request'};
  } else if(response.statusCode == 404) {
    return {ResponseType.notFound: 'refused'};
  } else {
    return {ResponseType.serverError: ''};
  }
}

enum ResponseType{
  success,
  bad,
  notFound,
  serverError,
}