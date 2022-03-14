import 'package:flutter/material.dart';
import 'package:shodai_mama/model/item_model.dart';

class DetailsScreen extends StatefulWidget {
  final ItemModel itemModel;
  const DetailsScreen(this.itemModel, {Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text(widget.itemModel.author),
          Text(widget.itemModel.height.toString()),
          Text(widget.itemModel.width.toString()),
          Text(widget.itemModel.url),
        ],
      ),
    ));
  }
}
