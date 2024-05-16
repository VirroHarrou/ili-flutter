class Routes {
  static const String main = '/';
  static const String platformList = '/platform_list';
  static const String platform = '/platform';
  static const String qrScanner = '/qr_scanner';
  static const String auth = '/auth';
  static const String loadingPage = '/load';
  static const String modelsList = '/model_list';
  static const String arView = '/ar_view';
}

enum NavigatorRoute {
  home(Routes.platformList),
  models(Routes.modelsList);

  final String path;
  const NavigatorRoute(this.path);
}