import 'package:shodai_mama/model/item_model.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<List<ItemModel>> fetchItem(int page, int limit) async {
    const _baseUrl = ' https://picsum.photos/v2/list ';

    final response =
        await http.get(Uri.parse('$_baseUrl?page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      var data = response.body;
      return itemModelFromJson(data);
    } else {
      throw Exception("Error");
    }
  }
}
