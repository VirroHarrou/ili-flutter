part of 'qr_bloc.dart';

abstract class QRState {}

class QRDefault extends QRState {}

class QRBarCodeFailure extends QRState {}

class QRCodeFailure extends QRState {}

class QRFailure extends QRState {}