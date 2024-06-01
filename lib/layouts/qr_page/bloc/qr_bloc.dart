import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/services/model_service.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QRBloc extends Bloc<QREvent, QRState> {
  final modelService = Injector.appInstance.get<ModelService>();

  QRBloc() : super(QRDefault()) {

    on<QRBarCodeFindEvent>((event, emit) async {
      emit(QRDefault());
      final RegExp exp = RegExp(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');
      if (!exp.hasMatch(event.barCode)) {
        emit(QRBarCodeFailure());
      }
      var model = await modelService.getModelDetail(id: event.barCode);
      if (model == null) {
        emit(QRBarCodeFailure());
        return;
      }
      if (event.context.mounted) {
        event.context.push(Routes.loadingPage, extra: model);
      }
    });

    on<QRCodeCompleteEvent>((event, emit) async {
      emit(QRDefault());
      var model = await modelService.getModelDetail(code: event.code);
      if (model == null) {
        emit(QRCodeFailure());
        return;
      }
      if (event.context.mounted) {
        event.context.push(Routes.loadingPage, extra: model);
      }
    });
  }
}