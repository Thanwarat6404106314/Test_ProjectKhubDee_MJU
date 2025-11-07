import 'dart:convert';

import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/news.dart';

class NewsController {
  // List News
  Future getListNews() async {
    var url = Uri.parse(baseURL + '/news/list');

    http.Response response = await http.get(url, headers: headers);
    String utf8body = utf8.decode(response.bodyBytes);
    // print(utf8body);
    List<dynamic> jsonList = json.decode(utf8body);
    List<News> list = jsonList.map((e) => News.fromJsonToNews(e)).toList();
    return list;
  }

  // Add News
  Future addNews(
      String new_id,
      String title,
      String description,
      String position,
      String image, 
      String post_date,
      String officer) async {
    Map data = {
      "new_id": new_id,
      "title": title,
      "description": description,
      "position": position,
      "image": image,
      "post_date": post_date,
      "officer": officer
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/news/add');
    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  // Delete News
  Future deleteNews(String new_id) async {
    var url = Uri.parse(baseURL + '/news/delete/${new_id}');
    http.Response response =
        await http.delete(url, headers: headers, body: null);

    final utf8body = utf8.decode(response.bodyBytes);
    print('-------${utf8body}--------');
  }

  // Get News
  Future getNewsById(String new_id) async {
    var url = Uri.parse(baseURL + '/news/getbyid/${new_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      News? news = News.fromJsonToNews(jsonMap);
      return news;
    } else {
      return null;
    }
  }

  // // Update News
  Future updateNews(News news) async {
    Map<String, dynamic> data = news.fromNewsToJson();
    var url = Uri.parse(baseURL + '/news/update');
    var body = json.encode(data, toEncodable: myDateSeriallizer);
    http.Response response = await http.put(url, headers: headers, body: body);
    return response;
  }

  // แปลงวันที่เป็น String
  dynamic myDateSeriallizer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  // Search News
  Future getSearchNews(String searchtext) async {
    var url = Uri.parse(
        baseURL + '/news/search?searchtext=$searchtext&searchby=title');

    http.Response response = await http.get(url, headers: headers);
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    List<News> list = jsonList.map((e) => News.fromJsonToNews(e)).toList();
    return list;
  }
}
