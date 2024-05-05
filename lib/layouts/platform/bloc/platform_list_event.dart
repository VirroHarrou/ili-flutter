part of 'platform_list_bloc.dart';

abstract class PlatformListEvent {}

class PlatformListUpdateEvent extends PlatformListEvent {
  int skip;
  int count;
  PlatformListUpdateEvent({
    this.skip = 0,
    this.count = 10,
  });
}

class PlatformListSearchUpdateEvent extends PlatformListEvent {
  String query;
  PlatformListSearchUpdateEvent({required this.query});
}

class PlatformListNavigateEvent extends PlatformListEvent {
  Platform platform;
  PlatformListNavigateEvent({required this.platform});
}