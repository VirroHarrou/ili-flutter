part of 'platform_detail_bloc.dart';

@immutable
abstract class PlatformDetailEvent {}

class PlatformDetailUpdateEvent extends PlatformDetailEvent {
  final String id;

  PlatformDetailUpdateEvent({required this.id});
}

class PlatformDetailNextQuestion extends PlatformDetailEvent {
  //Todo: implement questionnaire data
}