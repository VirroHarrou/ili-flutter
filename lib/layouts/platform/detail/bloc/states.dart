part of 'platform_detail_bloc.dart';

@immutable
abstract class PlatformDetailState {}

class PlatformDetailInitState extends PlatformDetailState {
  final Platform platform;

  PlatformDetailInitState({required this.platform});
}

class PlatformDetailLoadedDefaultState extends PlatformDetailState{
  final Platform platform;

  PlatformDetailLoadedDefaultState({required this.platform});
}

class PlatformDetailLoadedPlusState extends PlatformDetailState {
  final Platform platform;
  final List<PlatformServicesModel> platformServices;
  final List<PlatformNewsModel> platformNews;
  final List<PlatformLinksModel> platformLinks;
  final List<Questionnaire> questionnaires;

  PlatformDetailLoadedPlusState({
    required this.platform,
    required this.platformServices,
    required this.platformNews,
    required this.platformLinks,
    required this.questionnaires,
  });
}
