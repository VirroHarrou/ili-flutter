import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/services/api_service.dart';

import 'models/model.dart';

class ModelService {
  SharedPreferences prefs;

  ModelService({
    required this.prefs,
  });

  Future<Model?> getModelDetail({String? code, String? id}) async {
    if (code == null && id == null) throw ArgumentError('Code or id must be initialized');
    Response? response;
    if (code != null) {
      switch (code.length){
        case 1:
          code = '000$code';
          break;
        case 2:
          code = '00$code';
          break;
        case 3:
          code = '0$code';
          break;
        default:
          break;
      }
      response = await ApiService.sendRequest(
        request: "model/code=$code",
      );
    } else {
      response = await ApiService.sendRequest(
        request: "model/id=$id",
      );
    }
    if (response == null) return null;
    if (response.statusCode == 200) {
      return Model.fromJson(response.data);
    }
    return null;
  }

  Future<List<Model>?> getModelList({required String id}) async {
    var response = await ApiService.sendRequest(
      request: "model/list/$id",
    );
    if (response == null) return null;
    if (response.statusCode == 200) {
      List modelsJson = response.data['models'];
      List<Model> models = [];
      for (var el in modelsJson){
        models.add(Model.fromJson(el));
      }
      return models;
    }
    return null;
  }
}