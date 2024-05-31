import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/services/api_service.dart';

class AuthService{
  final SharedPreferences prefs;

  String _accessToken = '';
  String _refreshToken = '';

  get accessToken => _accessToken;
  get refreshToken => _refreshToken;

  AuthService({
    required this.prefs,
  }) {
    _accessToken = prefs.getString('access_token') ?? '';
    _refreshToken = prefs.getString('refresh_token') ?? '';
  }

  Future<String> loginNoName() async{
    var response =
      await ApiService.sendRequest(
        request: "auth/noname",
        method: RequestMethod.get,
      );
    if(response?.statusCode == 200) {
      _accessToken = response?.data;
      prefs.setString('access_token', _accessToken);
      ApiService.restartService();
      return response?.data;
    }
    return '';
  }

  Future<String> loginxUser(
      {
        required String email,
        required String password
      }) async {
    var response =
        await ApiService.sendRequest(
          request: "auth/login",
          method: RequestMethod.post,
          data: <String, String>{
            "email":email,
            "password":password,
          },
        );
    if(response?.statusCode == 200) {
      _accessToken = response?.data;
      prefs.setString('access_token', _accessToken);
      return response?.data;
    }
    return '';
  }
}