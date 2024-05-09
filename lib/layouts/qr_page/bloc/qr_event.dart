part of 'qr_bloc.dart';

abstract class QREvent {}

class QRBarCodeFindEvent extends QREvent {
  BuildContext context;
  String barCode;
  QRBarCodeFindEvent({required this.barCode, required this.context});
}

class QRCodeCompleteEvent extends QREvent {
  BuildContext context;
  String code;
  QRCodeCompleteEvent({required this.code, required this.context});
}