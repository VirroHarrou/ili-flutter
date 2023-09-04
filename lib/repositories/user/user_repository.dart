import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';

Future<JwtResponse> tryLoginAsync(String email, String password) async {
  final connectionString = "${AppSettings.baseUri}api/1.0/auth/login";
  Dio dio = Dio();
  Response<dynamic> response;
  try {
    response = await dio.post(
      connectionString,
      data: {"email": email, "password": password},
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );
    if (response.statusCode == 200) {
      return JwtResponse(ResponseType.success, response.data);
    }
    if (response.statusCode == 400) {
      return JwtResponse(
          ResponseType.bad, 'Не существует аккаунта с такой эл. почтой');
    }
    if (response.statusCode == 404) {
      return JwtResponse(ResponseType.notFound, 'Неверный пароль');
    }
  } catch (ex) {
    if (ex is DioException) {
      print(ex.message);
    } else {
      print(ex);
    }
  }
  return JwtResponse(ResponseType.serverError, null);
}

Future<ResponseType> tryRegister(String email, String password) async {
  const connectionString = "http://185.233.187.109/api/1.0/auth/signup";
  Dio dio = Dio();
  var response = await dio.post(connectionString, data: {
    "userName": email,
    "email": email,
    "password": password,
  },
  options: Options(
    validateStatus: (status) => status! < 500,
    followRedirects: false,
  ));

  if(response.statusCode == 204) {
    return ResponseType.success;
  }
  return ResponseType.bad;
}

class JwtResponse {
  JwtResponse(this.type, this.data);

  ResponseType? type;
  String? data;
}

enum ResponseType {
  success,
  bad,
  notFound,
  serverError,
}
