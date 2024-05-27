part of 'model_list_bloc.dart';

abstract class ModelListState {}

class ModelListInitState extends ModelListState {}

class ModelListLoadingState extends ModelListState {}

class ModelListLoadedState extends ModelListState {
  List<Model> models;
  ModelListLoadedState({required this.models});
}

class ModelListFailureState extends ModelListState {
  String message;
  ModelListFailureState({required this.message});
}

class ModelListEmptyState extends ModelListState {}