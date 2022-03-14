// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shodai_mama/constants/http_service/http_service.dart';
import 'package:shodai_mama/controller/item_controller.dart';
import 'package:shodai_mama/model/item_model.dart';
import 'package:shodai_mama/view/screens/item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasNextPage = true;

  bool _isFirstLoadRunning = false;

  bool _isLoadMoreRunning = false;

  int _page = 0;
  final int _limit = 20;
  late ScrollController controller;
  void firstLoad() async {
    final provider = Provider.of<ItemProvider>(context, listen: false);

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      var response = await HttpService.fetchItem(_page, _limit);

      provider.updateItemList(response);
    } catch (err) {
      debugPrint('Something went wrong here');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    final provider = Provider.of<ItemProvider>(context, listen: false);
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1; // Increase __page by 1
      try {
        final response = await HttpService.fetchItem(_page, _limit);

        final List<ItemModel> fetchedPosts = response;
        if (fetchedPosts.isNotEmpty) {
          provider.updateLoadMoreItemList(fetchedPosts);
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        debugPrint('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firstLoad();

    controller = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    controller.removeListener(loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Item List'),
        ),
        body: Consumer<ItemProvider>(builder: (context, provider, child) {
          return _isFirstLoadRunning
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: provider.itemList.length,
                        itemBuilder: (_, index) => Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailsScreen(
                                        provider.itemList[index]))),
                            child: ListTile(
                              title: Text(provider.itemList[index].id),
                              trailing: Text(provider.itemList[index].author),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // When nothing else to load
                    if (_hasNextPage == false)
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 40),
                        color: Colors.amber,
                        child: const Center(
                          child: Text('You have fetched all of the content'),
                        ),
                      ),
                  ],
                );
        }));
  }
}
