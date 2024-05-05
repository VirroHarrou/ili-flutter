part of 'platform_list_bloc.dart';

abstract class PlatformListState {}

class PlatformListLoading extends PlatformListState {}

class PlatformListLoaded extends PlatformListState {
  List<Platform> platforms;
  PlatformListLoaded({required this.platforms});
}

class PlatformListFailure extends PlatformListState {
  String message;
  PlatformListFailure({required this.message});
}

class PlatformListEmpty extends PlatformListState {}