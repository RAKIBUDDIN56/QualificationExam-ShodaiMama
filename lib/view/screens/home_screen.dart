// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shodai_mama/constants/http_service/http_service.dart';
import 'package:shodai_mama/controller/item_controller.dart';
import 'package:shodai_mama/model/item_model.dart';
import 'package:shodai_mama/shared_components/widgets/shared_widgets.dart';
import 'package:shodai_mama/view/screens/item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //to check page number
  bool _hasNextPage = true;
  //to check if request is running
  bool _isFirstLoadRunning = false;
  //to check if items are loading
  bool _isLoadMoreRunning = false;
  //initial page
  int _page = 0;
  //limit
  final int _limit = 20;
  late ScrollController controller;

  //funtion to load initial page
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

  //function to load more items
  void loadMore() async {
    final provider = Provider.of<ItemProvider>(context, listen: false);
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 200) {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Item List',
            textAlign: TextAlign.center,
            style: style(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Consumer<ItemProvider>(builder: (context, provider, child) {
          return _isFirstLoadRunning
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.teal,
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: height * .03,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * .1,
                        ),
                        Expanded(
                            child: Text(
                          'Id',
                          style: style(
                              fontSize: 22,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            child: Text(
                          'Author',
                          style: style(
                              fontSize: 22,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: provider.itemList.length,
                        itemBuilder: (_, index) => Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: width * .05),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailsScreen(
                                        provider.itemList[index]))),
                            child: ListTile(
                              title: Text(
                                provider.itemList[index].id,
                                style: style(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal),
                              ),
                              trailing: Text(provider.itemList[index].author,
                                  style: style(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
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
