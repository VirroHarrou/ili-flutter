part of 'model_list_bloc.dart';

abstract class ModelListEvent {}

class ModelDeleteEvent extends ModelListEvent {
  String id;
  ModelDeleteEvent({required this.id});
}

class ModelListUpdateEvent extends ModelListEvent {}

class ModelListInitEvent extends ModelListEvent {}