import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/services/platform_service.dart';

part 'platform_list_event.dart';
part 'platform_list_state.dart';

class PlatformListBloc extends Bloc<PlatformListEvent, PlatformListState> {
  final platformService = Injector.appInstance.get<PlatformService>();
  List<Platform> platforms = [];

  PlatformListBloc() : super(PlatformListEmpty()) {
    on<PlatformListUpdateEvent>((event, emit) async {
      if (platforms.isEmpty) emit(PlatformListLoading());
      print(event.count);
      var result = await updateData(skip: event.skip, count: event.count);

      if (result.isEmptyOrNull) {
        emit(PlatformListFailure(
          message: 'При обновлении данных произошла ошибка, пожалуйста попробуйте позже',
        ));
        return;
      }

      platforms.addAll(result!);
      emit(PlatformListLoaded(platforms: platforms));
    });

    on<PlatformListSearchUpdateEvent>((event, emit) async {
      //Todo: implement logic without load data from server (if data exist)
      var result = await updateDataSearch(event.query);

      if (!result.isEmptyOrNull){
        platforms = result!;
        emit(PlatformListLoaded(platforms: platforms));
        return;
      }

      if (state is PlatformListFailure) return;

      emit(PlatformListEmpty());
    });
  }

  Future<List<Platform>?> updateData({skip, count}) async =>
      await platformService.getPlatformList(skip: skip, count: count);

  Future<List<Platform>?> updateDataSearch(query) async =>
      await platformService.getPlatformListSearch(query: query);
}