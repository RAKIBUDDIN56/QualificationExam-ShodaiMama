import 'dart:convert';

List<ItemModel> itemModelFromJson(String item) =>
    List<ItemModel>.from(json.decode(item).map((x) => ItemModel.fromJson(x)));

class ItemModel {
  String id;
  String author;
  int width;
  int height;
  String url;
  String downloadUrl;
  ItemModel({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        author: json["author"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        downloadUrl: json["download_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "width": width,
        "height": height,
        "url": url,
        "download_url": downloadUrl,
      };
}
