import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/services/models/questionnaire.dart';
import 'package:tavrida_flutter/services/platform_service.dart';
import 'package:tavrida_flutter/services/questionnaire_service.dart';

import '../widgets/platform_elements_serializer.dart';
import '../widgets/question_controller.dart';

part 'events.dart';
part 'states.dart';

class PlatformDetailBloc extends Bloc<PlatformDetailEvent, PlatformDetailState> {
  Platform platform;
  final platformService = Injector.appInstance.get<PlatformService>();
  final questionnaireService = Injector.appInstance.get<QuestionnaireService>();

  final List<PlatformServicesModel> _services = [];
  final List<PlatformNewsModel> _news = [];
  final List<PlatformLinksModel> _links = [];

  PlatformDetailBloc(this.platform) : super(PlatformDetailInitState(platform: platform)) {

    on<PlatformDetailUpdateEvent>((event, emit) async {
      platform = await tryUpdatePlatform(platform);
      switch (platform.platformType) {
        case 1:  //Default
          emit(PlatformDetailLoadedDefaultState(platform: platform));
        case 2:  //Platform plus
          await _configurePlatformElements(platform.platformElements);
          final questionnaires = await _getQuestionnaires(platform.id ?? '');
          emit(PlatformDetailLoadedPlusState(
            platform: platform,
            platformServices: _services,
            platformNews: _news,
            platformLinks: _links,
            questionnaires: questionnaires,
          ));
        default:  //Unknown (0)
          emit(PlatformDetailLoadedDefaultState(platform: platform));
      }
    });
  }

  Future<Platform> tryUpdatePlatform(Platform platform) async {
    var result = await platformService.getPlatformDetail(id: platform.id ?? '');
    if (result == null) return platform;
    if (result == platform) return platform;
    result.id = platform.id;
    return result;
  }


  Future<void> _configurePlatformElements(List<dynamic> json) async {
    while (!json.isEmptyOrNull){
      final jsonElement = json.first;
      final String type = jsonElement['type'] ?? '';
      json.removeAt(0);
      switch (type) {
        case 'PlatformNews':
          _news.add(PlatformNewsModel.fromJson(jsonElement));
          break;
        case 'PlatformService':
          _services.add(PlatformServicesModel.fromJson(jsonElement));
          break;
        case 'PlatformLink':
          _links.add(PlatformLinksModel.fromJson(jsonElement));
          break;
        default:
          debugPrint('Platform element undetected: $jsonElement');
          break;
      }
    }
  }


  Future<List<Questionnaire>> _getQuestionnaires(String id) async {
    final data = await questionnaireService.getQuestionnaireList(id: id);
    if (data.isEmptyOrNull) return [];
    return data!;
  }
}

enum AdditionalTypes {
  news,
  services,
  links,
}