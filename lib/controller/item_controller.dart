import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shodai_mama/constants/http_service/http_service.dart';
import 'package:shodai_mama/model/item_model.dart';

class ItemController extends GetxController {
  final _hasNextPage = true.obs;

  final _isFirstLoading = false.obs;
  late ScrollController _scrollController;
  // Used to display loading indicators when _loadMore function is running
  final _isMoreLoading = false.obs;
  var itemList = <ItemModel>[].obs;

  int _page = 0;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
    _scrollController = ScrollController()..addListener(_fetchItemMore);
  }

  @override
  void onClose() {
    _scrollController.removeListener(_fetchItemMore);
    super.onClose();
  }

  void _fetchItems() async {
    try {
      _isFirstLoading(true);

      var data = await HttpService.fetchItem(_page, _limit);

      if (data.isNotEmpty) {
        itemList.value = data;
      } else {
        throw Exception('Error here');
      }
    } finally {
      _isFirstLoading(false);
    }
  }

  void _fetchItemMore() async {
    if (_hasNextPage.isTrue &&
        _isFirstLoading.isFalse &&
        _isMoreLoading.isFalse &&
        _scrollController.position.extentAfter < 200) {
      _isMoreLoading(true);
      _page += 1;

      try {
        final response = await HttpService.fetchItem(_page, _limit);

        if (response.isNotEmpty) {
          itemList.addAll(response);
        } else {
          _hasNextPage(false);
        }
      } catch (e) {
        debugPrint('Something wrong');
      }
    }
  }
}
