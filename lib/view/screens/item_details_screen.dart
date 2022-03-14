import 'package:flutter/material.dart';
import 'package:shodai_mama/model/item_model.dart';
import 'package:shodai_mama/shared_components/widgets/shared_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final ItemModel itemModel;
  const DetailsScreen(this.itemModel, {Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  void _launchURL() async {
    if (await canLaunch(widget.itemModel.url)) {
      await launch(widget.itemModel.url);
    } else {
      throw 'Could not launch ${widget.itemModel.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Item Details',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: height * .03,
          ),
          Row(
            children: [
              SizedBox(
                width: width * .02,
              ),
              Expanded(
                child: Text(
                  'Author :',
                  style: style(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  widget.itemModel.author,
                  style: style(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: width * .02,
              ),
              Expanded(
                child: Text(
                  'Height :',
                  style: style(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  widget.itemModel.height.toString(),
                  style: style(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: width * .02,
              ),
              Expanded(
                child: Text(
                  'Width :',
                  style: style(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  widget.itemModel.width.toString(),
                  style: style(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: width * .02,
              ),
              Expanded(
                  child: Text(
                'Image Url :',
                style: style(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              )),
              Expanded(
                flex: 2,
                child: TextButton(
                    onPressed: () {
                      debugPrint('Clicked');
                      _launchURL();
                    },
                    child: Text(
                      widget.itemModel.url,
                      style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Colors.green),
                    )),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
