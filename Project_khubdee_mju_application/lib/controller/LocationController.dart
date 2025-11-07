import 'dart:convert';

import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/location.dart';

class LocationController {
  // List Location
  Future getListLocation() async {
    var url = Uri.parse(baseURL + '/location/list');

    http.Response response = await http.get(url, headers: headers);
    String utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    List<Location> list = jsonList.map((e) => Location.fromJsonToLocation(e)).toList();
    return list;
  }

  Future getLocationById(String location_id) async {
    var url = Uri.parse(baseURL + '/location/getbyid/${location_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      Location? location = Location.fromJsonToLocation(jsonMap);
      return location;
    } else {
      return null;
    }
  }
}
