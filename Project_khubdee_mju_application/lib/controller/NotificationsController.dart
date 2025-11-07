import 'dart:convert';
import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/notifications.dart';

class NotificationsController {
  // List Notification
  // Future getListNotifications() async {
  //   var url = Uri.parse(baseURL + '/notification/list');
  //   http.Response response = await http.get(url, headers: headers);
  //   print('Repo: ${response.statusCode}');

  //   String utf8body = utf8.decode(response.bodyBytes);
  //   print('utf8body: ${utf8body.toString()}');
  //   List<dynamic> jsonList = json.decode(utf8body);
  //   List<Notifications> list =
  //       jsonList.map((e) => Notifications.fromJsonToNotification(e)).toList();
  //   return list;
  // }

  // List Notification By StudentID
  Future getListNotificationsByStudentID(String student_id) async {
    var url = Uri.parse(baseURL + '/notification/list/${student_id}');
    http.Response response = await http.get(url, headers: headers);
    // print('Repo: ${response.statusCode}');

    String utf8body = utf8.decode(response.bodyBytes);
    // print('utf8body: ${utf8body.toString()}');
    List<dynamic> jsonList = json.decode(utf8body);
    List<Notifications> list =
        jsonList.map((e) => Notifications.fromJsonToNotification(e)).toList();
    return list;
  }

  // Add Notification
  Future addNotification(String recordViolation) async {
    Map data = {
      "recordViolation": recordViolation,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/notification/add');
    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  // Delete Notification
  Future deleteNotification(String notification_id) async {
    var url = Uri.parse(baseURL + '/notification/delete/${notification_id}');
    http.Response response =
        await http.delete(url, headers: headers, body: null);

    final utf8body = utf8.decode(response.bodyBytes);
    print('-------${utf8body}--------');
  }

  // Get Notification
  Future getNotificationById(String notification_id) async {
    var url = Uri.parse(baseURL + '/notification/getbyid/${notification_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      Notifications? notifications =
          Notifications.fromJsonToNotification(jsonMap);
      return notifications;
    } else {
      return null;
    }
  }

  // Update Status Notification
  Future<void> updateStatus(String notification_id) async {
    var url =
        Uri.parse(baseURL + '/notification/updateStatus/${notification_id}');
    http.Response response = await http.put(url, headers: headers);

    print("RES CODE IS : ${response.statusCode}");
  }

}
