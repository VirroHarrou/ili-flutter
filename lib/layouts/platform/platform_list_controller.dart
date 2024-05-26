import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/services/platform_service.dart';

class PlatformListController {
  final _platformService = Injector.appInstance.get<PlatformService>();
  final pageController = PagingController<int, Platform>(firstPageKey: 0);
  static int pageSize = 10;
  String filter = '';
  String _previousFilter = '';

  void init() => pageController.addPageRequestListener((number) =>
      _fetchPage(number));

  void dispose() => pageController.dispose();

  Future<List<Platform>?> _updateData({skip, count}) async =>
      await _platformService.getPlatformList(skip: skip, count: count);

  Future<List<Platform>?> _updateDataSearch(query) async =>
      await _platformService.getPlatformListSearch(query: query);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = filter.isEmpty
          ? await _updateData(skip: pageKey, count: pageSize)
          : await _updateDataSearch(filter);
      if (filter.isNotEmpty && filter != _previousFilter) {
        pageController.refresh();
        _previousFilter = filter;
      }
      final isLastPage = newItems!.length < pageSize;
      if (isLastPage) {
        pageController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pageController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pageController.error = error;
    }
  }
}