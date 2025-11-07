import 'dart:convert';

import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/officer.dart';

class OfficerController {
  
  // List Officer
  Future getListOfficer() async {
    var url = Uri.parse(baseURL + '/officer/list');

    http.Response response = await http.get(url, headers: headers);
    String utf8body = utf8.decode(response.bodyBytes);
    print(utf8body);
    List<dynamic> jsonList = json.decode(utf8body);
    List<Officer> list =
        jsonList.map((e) => Officer.fromJsonToOfficer(e)).toList();
    return list;
  }

  // Add Officer
  Future addOfficer(
    String officer_id, 
    String firstname, 
    String lastname,
    String position, 
    String email, 
    String password) async {
    Map data = {
      "officer_id": officer_id,
      "firstname": firstname,
      "lastname": lastname,
      "position": position,
      "email": email,
      "password": password
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/officer/add');
    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  // Delete Officer
  Future deleteOfficer(String officer_id) async {
    var url = Uri.parse(baseURL + '/officer/delete/${officer_id}');
    http.Response response =
        await http.delete(url, headers: headers, body: null);

    final utf8body = utf8.decode(response.bodyBytes);
    print('-------${utf8body}--------');
  }

  // Get by ID
  Future getOfficerById(String officer_id) async {
    var url = Uri.parse(baseURL + '/officer/getbyid/${officer_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      Officer? officer = Officer.fromJsonToOfficer(jsonMap);
      return officer;
    } else {
      return null;
    }
  }

  // Get by Email
  Future getOfficerByEmail(String email) async {
    var url = await Uri.parse(baseURL + '/officer/getbyemail/${email}');
    http.Response response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      Officer? officer = Officer.fromJsonToOfficer(jsonMap);
      return officer;
    } else {
      return null;
    }
  }

  // Login Officer
  Future officerLogin(String email, String password) async {
    Map data = {"email": email, "password": password};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/officer/loginofficer');

    http.Response response = await http.post(url, headers: headers, body: body);
    return response;
  }

  Future updateStudent(Officer officer) async {
    Map<String, dynamic> data = officer.fromOfficerToJson();

    var body = json.encode(data, toEncodable: myDateSeriallizer);
    var url = Uri.parse(baseURL + '/officer/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }
  dynamic myDateSeriallizer(dynamic object){
    if(object is DateTime){
      return object.toIso8601String();
    }
    return object;

  }
}
