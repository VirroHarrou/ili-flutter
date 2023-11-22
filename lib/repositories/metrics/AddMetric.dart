import 'package:dio/dio.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';

class MetricRepos {
  static Future<void> createRecord(String entityId, MetricType type, int value) async {
    final connectionString = "${AppSettings.baseUri}api/1.0/metrics/create";

    Dio dio = Dio();

    dio.options.headers["Authorization"] = "Bearer ${AppSettings.authToken}";
    await dio.post(
      connectionString,
      queryParameters: <String, dynamic>{
        "entityId" : entityId,
        "entityType" : type.index,
        "value" : value,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) => status! <= 500,
      ),
    );
  }

  Future<void> updateRecord() async {

  }
}

enum MetricType{
  none,
  forums,
  users,
  modelViews,
  modelPhotos,
  qrScreen,
  arScreen,
  forumListScreen,
}