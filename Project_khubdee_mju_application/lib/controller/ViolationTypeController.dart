import 'dart:convert';

import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/violationtype.dart';

class ViolationTypeController {
  // List News
  Future getListViolationType() async {
    var url = Uri.parse(baseURL + '/violationtype/list');

    http.Response response = await http.get(url, headers: headers);
    String utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    List<ViolationType> list = jsonList.map((e) => ViolationType.fromJsonToViolationType(e)).toList();
    return list;
  }

  Future getViolationTypeById(String violation_id) async {
    var url = Uri.parse(baseURL + '/violationtype/getbyid/${violation_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      ViolationType? violationType = ViolationType.fromJsonToViolationType(jsonMap);
      return violationType;
    } else {
      return null;
    }
  }
}