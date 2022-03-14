import 'package:flutter/cupertino.dart';
import 'package:shodai_mama/model/item_model.dart';

class ItemProvider extends ChangeNotifier {
  bool isFirstLoadRunning = false;

  List<ItemModel> itemList = [];

  void updateItemList(List<ItemModel> list) {
    itemList = list;
    notifyListeners();
  }

  void updateLoadMoreItemList(List<ItemModel> list) {
    itemList.addAll(list);
    notifyListeners();
  }
}



























// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:shodai_mama/constants/http_service/http_service.dart';
// import 'package:shodai_mama/model/item_model.dart';

// class ItemController extends GetxController {
//   final hasNextPage = true.obs;

//   final isFirstLoading = false.obs;
//   late ScrollController _scrollController;
//   // Used to display loading indicators when _loadMore function is running
//   final isMoreLoading = false.obs;
//   var itemList = <ItemModel>[].obs;

//   int _page = 0;
//   final int _limit = 20;

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchItems();

//     ///_fetchItemMore();
//     _scrollController = ScrollController()..addListener(_fetchItemMore);
//   }

//   @override
//   void onClose() {
//     // _scrollController.removeListener(_fetchItemMore);
//     super.onClose();
//   }

//   void _fetchItems() async {
//     try {
//       isFirstLoading(true);

//       var data = await HttpService.fetchItem(_page, _limit);

//       if (data.isNotEmpty) {
//         itemList.value = data;
//       } else {
//         throw Exception('Error here');
//       }
//     } catch (e) {
//       debugPrint('Error');
//     }
//     isFirstLoading(false);
//   }

//   void _fetchItemMore() async {
//     print('yes');
//     if (hasNextPage.isTrue == true &&
//         _scrollController.position.extentAfter < 300) {
//       isMoreLoading(true);
//       _page += 1;

//       try {
//         final response = await HttpService.fetchItem(_page, _limit);
//         print('called');

//         if (response.isNotEmpty) {
//           itemList.value = response;
//           itemList.addAll(response);
//         } else {
//           hasNextPage(false);
//         }
//       } catch (e) {
//         debugPrint('Something wrong');
//       }
//     }
//   }
// }
