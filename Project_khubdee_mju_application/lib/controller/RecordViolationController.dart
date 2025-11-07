import 'dart:convert';
import 'dart:io';

import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/recordviolation.dart';
import 'package:http_parser/http_parser.dart';

class RecordViolationController {
  // List RecordViolation
  Future getListRecordViolation() async {
    var url = Uri.parse(baseURL + '/recordviolation/list');
    http.Response response = await http.get(url, headers: headers);
    String utf8body = utf8.decode(response.bodyBytes);
    // print("utf8body: "+ utf8body);
    List<dynamic> jsonList = json.decode(utf8body);
    List<RecordViolation> list = jsonList
        .map((e) => RecordViolation.fromJsonToRecordViolation(e))
        .toList();
    return list;
  }

  // List Notification By StudentID
  Future getListRecordViolationByStudentID(String student_id) async {
    var url = Uri.parse(baseURL + '/recordviolation/list/${student_id}');
    http.Response response = await http.get(url, headers: headers);
    // print('Repo: ${response.statusCode}');
    String utf8body = utf8.decode(response.bodyBytes);
    // print('utf8body: ${utf8body.toString()}');
    List<dynamic> jsonList = json.decode(utf8body);
    List<RecordViolation> list =
        jsonList.map((e) => RecordViolation.fromJsonToRecordViolation(e)).toList();
    return list;
  }

  // Add RecordViolation
  Future addRecordViolation(
      String record_date,
      File picture_evidence, //ใช้ File ถ้าต้องการอัปโหลดรูปภาพ
      String student,
      String officer,
      String location,
      String violationType) async {
    Map data = {
      "student": student,
      "record_date": record_date,
      "officer": officer,
      "location": location,
      "violationType": violationType
    };

    // อัปโหลดไฟล์และรับพาธของไฟล์
    var pathPicture_Evidence = await uploadImages(picture_evidence);

    // เพิ่มพาธของไฟล์ลงในข้อมูล
    data["picture_evidence"] = pathPicture_Evidence;

    // แปลงข้อมูลเป็น JSON
    var body = json.encode(data);

    // ส่งข้อมูลไปยังเซิร์ฟเวอร์
    var url = Uri.parse(baseURL + '/recordviolation/add');
    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['record_id']; // คืนค่า record_id
    } else {
      throw Exception('Failed to add record violation');
    }
  }

  // Upload Image
  Future<String> uploadImages(File? image) async {
    // ตรวจสอบว่า image ไม่เป็น null ก่อนใช้
    if (image != null) {
      try {
        var uri = Uri.parse(baseURL + "/recordviolation/upload");

        var request = http.MultipartRequest('POST', uri);
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();

        String fileExtension = image.path.split('.').last.toLowerCase(); // นามสกุลไฟล์
        MediaType mediaType;

        if (fileExtension == 'png') {
          mediaType = MediaType('image', 'png');
        } else {
          mediaType = MediaType('image', 'jpg'); // กรณีเริ่มต้นเป็น jpg
        }

        var multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: image.path.split('/').last,
          contentType: mediaType,
        );
        request.files.add(multipartFile);

        var response = await request.send();

        if (response.statusCode == 200) {
          var jsonResponse = await response.stream.bytesToString();
          print("Image uploaded successfully: $jsonResponse"); // Debug log
          return jsonResponse;
        } else {
          throw Exception(
              'Failed to upload image. Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print(e);
        throw Exception('$e');
      }
    } else {
      throw Exception('Image file is null');
    }
  }

  // Get News
  Future getRecordViolationById(String record_id) async {
    var url = Uri.parse(baseURL + '/recordviolation/getbyid/${record_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      RecordViolation? recordViolation =
          RecordViolation.fromJsonToRecordViolation(jsonMap);
      return recordViolation;
    } else {
      return null;
    }
  }
}
