import 'package:flutter/cupertino.dart';
import 'package:tavrida_flutter/services/api_service.dart';
import 'package:tavrida_flutter/services/models/platform.dart';

class PlatformService {
  Future<List<Platform>?> getPlatformList({count = 10, skip = 0}) async {
    var response =
        await ApiService.sendRequest(
          request: "platform/list?Count=$count&Skiped=$skip",
        );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      List jsonPlatformList = response.data['platformList'];
      List<Platform> platformList = [];
      for (var element in jsonPlatformList) {
        platformList.add(Platform.fromJson(element));
      }
      return platformList;
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Platform>?> getPlatformListSearch({required String query}) async {
    var response =
      await ApiService.sendRequest(
        request: "platform/list/$query",
      );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      List jsonPlatformList = response.data;
      List<Platform> platformList = [];
      for (var element in jsonPlatformList) {
        platformList.add(Platform.fromJson(element));
      }
      return platformList;
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Platform?> getPlatformDetail({required String id}) async {
    var response =
        await ApiService.sendRequest(
          request: "platform/$id",
        );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      var pl = Platform.fromJson(response.data);
      return pl;
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<PlatformElement>?> getPlatformElements({required String id}) async {
    var response =
      await ApiService.sendRequest(
        request: "platform/elements/list/$id",
      );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      List jsonPlatformElementList = response.data;
      List<PlatformElement> platformElements = [];
      for (var element in jsonPlatformElementList) {
        platformElements.add(PlatformElement.fromJson(element));
      }
      return platformElements;
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }
}