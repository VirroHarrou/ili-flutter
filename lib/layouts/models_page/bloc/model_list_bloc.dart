import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/services/model_service.dart';
import 'package:tavrida_flutter/services/models/model.dart';

part 'model_list_event.dart';
part 'model_list_state.dart';

class ModelListBloc extends Bloc<ModelListEvent, ModelListState> {
  List<Model> models = [];
  List<String> downloaded = [];
  final modelService = Injector.appInstance.get<ModelService>();

  ModelListBloc() : super(ModelListInitState()) {
    on<ModelListInitEvent>((event, emit) async {
      emit(ModelListLoadingState());
      downloaded = await _getDownloadedModels();
      add(ModelListUpdateEvent());
    });

    on<ModelListUpdateEvent>((event, emit) async {
      if (downloaded.isEmpty) {
        emit(ModelListEmptyState());
        return;
      }
      for (var id in downloaded) {
        if (models.any((element) => element.id == id)) continue;

        var model = await _getModelData(id);

        model ??= Model(
          id: '',
          title: 'Сломанная модель',
          logoUrl: 'https://i1.sndcdn.com/artworks-000610006042-grtxxe-t500x500.jpg',
        );

        models.add(model);
      }
      if (models.isEmpty){
        emit(ModelListFailureState(
          message: 'При обновлении данных произошла ошибка, пожалуйста попробуйте позже',
        ));
        return;
      }
      emit(ModelListLoadedState(models: models));
    });

    on<ModelDeleteEvent>((event, emit) async {
      await _deleteModelFile(event.id);
      models.removeWhere((element) => element.id == event.id);
      downloaded.remove(event.id);
      add(ModelListUpdateEvent());
    });
  }

  Future<List<String>> _getDownloadedModels() async {
    var dir = await getApplicationDocumentsDirectory();
    var ids = <String>[];
    await dir.list().forEach((element) {
      //get uuid from file name
      //Todo: add versioning models file
      String id = element.path.split('/').last.toString().split('.').first.toString();
      if (id.length == 36) {
        ids.add(id);
      }
    });
    return ids;
  }

  Future<Model?> _getModelData(String id) async =>
      await modelService.getModelDetail(id: id);

  Future<void> _deleteModelFile(String id) async {
    var dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$id.${Platform.isAndroid ? 'glb' : 'usdz'}');
    await file.delete();
  }

}