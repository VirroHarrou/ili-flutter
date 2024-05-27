import 'package:injector/injector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/services/api_service.dart';
import 'package:tavrida_flutter/services/model_service.dart';
import 'package:tavrida_flutter/services/platform_service.dart';
import 'package:tavrida_flutter/services/questionnaire_service.dart';

import '../services/auth_service.dart';

class InjectorInitializer{
  static Future<Injector> initialize(Injector injector) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    PackageInfo info = await PackageInfo.fromPlatform();

    injector.registerSingleton(() => info);
    injector.registerSingleton(() => AuthService(prefs: preferences));
    injector.registerSingleton(() => PlatformService());
    injector.registerSingleton(() => QuestionnaireService(prefs: preferences));
    injector.registerSingleton(() => ModelService(prefs: preferences));

    return injector;
  }
}