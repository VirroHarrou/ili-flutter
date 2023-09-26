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
          ResponseType.bad, 'Почта введена неверно');
    }
    if (response.statusCode == 404) {
      return JwtResponse(ResponseType.notFound, 'Не существует аккаунта с такими\nэл. почтой и/или паролем');
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

Future<JwtResponse> tryRegister(String email, String password) async {
  final connectionString = "${AppSettings.baseUri}api/1.0/auth/signup";
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
  if(response.statusCode == 200) {
    return JwtResponse(ResponseType.success, response.data);
  }
  return JwtResponse(ResponseType.bad, '');
}

Future<void> tryDeleteUser() async {
  //Todo: сделать с проверкой пароля
  final connectionString = "${AppSettings.baseUri}api/1.0/auth/";
  Dio dio = Dio();
  var response = await dio.delete(connectionString,
      options: Options(
        validateStatus: (status) => status! < 500,
      ));
}

Future<JwtResponse> tryCreateNoNameUser() async {
  //Todo: сделать с проверкой пароля
  final connectionString = "${AppSettings.baseUri}api/1.0/auth/noname";
  Dio dio = Dio();
  var response = await dio.get(connectionString,
      options: Options(
        validateStatus: (status) => status! < 500,
      ));
  if(response.statusCode == 200) {
    return JwtResponse(ResponseType.success, response.data);
  }
  return JwtResponse(ResponseType.bad, '');
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
