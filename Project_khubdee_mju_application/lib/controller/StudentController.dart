import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:project_final/constants/constant_value.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/model/student.dart';

class StudentController {
  // List Student
  Future getListStudent() async {
    var url = Uri.parse(baseURL + '/student/list');

    http.Response response = await http.get(url, headers: headers);
    String utf8body = utf8.decode(response.bodyBytes);
    print(utf8body);
    List<dynamic> jsonList = json.decode(utf8body);
    List<Student> list =
        jsonList.map((e) => Student.fromJsonToStudent(e)).toList();
    return list;
  }

  // Add Student
  Future addStudent(
      String student_id,
      String firstname,
      String lastname,
      int student_score,
      String major,
      String faculty,
      File img_student,
      String email,
      String password) async {
    Map data = {
      "student_id": student_id,
      "firstname": firstname,
      "lastname": lastname,
      "student_score": student_score,
      "major": major,
      "faculty": faculty,
      "email": email,
      "password": password
    };

    // อัปโหลดไฟล์และรับพาธของไฟล์
    var pathImg_Student = await uploadImages(img_student);

    // เพิ่มพาธของไฟล์ลงในข้อมูล
    data["img_student"] = pathImg_Student;

    // แปลงข้อมูลเป็น JSON
    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/student/add');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  // Upload Image
  Future<String> uploadImages(File? image) async {
    // ตรวจสอบว่า image ไม่เป็น null ก่อนใช้
    if (image != null) {
      try {
        var uri = Uri.parse(baseURL + "/student/upload");

        var request = http.MultipartRequest('POST', uri);
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();

        String fileExtension =
            image.path.split('.').last.toLowerCase(); // นามสกุลไฟล์
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
          print("Image uploaded success: $jsonResponse"); // Debug log
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

  // Delete Student
  Future deleteStudent(String student_id) async {
    var url = Uri.parse(baseURL + '/student/delete/${student_id}');
    http.Response response =
        await http.delete(url, headers: headers, body: null);

    final utf8body = utf8.decode(response.bodyBytes);
    print('-------${utf8body}--------');
  }

  // Get By ID
  Future getStudentById(String student_id) async {
    var url = Uri.parse(baseURL + '/student/getbyid/${student_id}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      Student student = Student.fromJsonToStudent(jsonMap);
      return student;
    } else {
      return null;
    }
  }

  // Get By Email
  Future getStudentByEmail(String email) async {
    var url = Uri.parse(baseURL + '/student/getbyemail/${email}');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final utf8body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8body);
      Student student = Student.fromJsonToStudent(jsonMap);
      return student;
    } else {
      return null;
    }
  }

  // Login Student
  Future studentLogin(String email, String password) async {
    Map data = {"email": email, "password": password};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/student/loginstudent');

    http.Response response = await http.post(url, headers: headers, body: body);
    return response;
  }

  // UpdateStudent
  Future updateStudent(Student student) async {
    Map<String, dynamic> data = student.fromStudentToJson();

    var body = json.encode(data, toEncodable: myDateSeriallizer);
    var url = Uri.parse(baseURL + '/student/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  dynamic myDateSeriallizer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  // Update Student Image
  Future updateStudentImage(String student_id, File? img_student) async {
    Map data = {
      // ไม่ต้องใส่ student_id ใน body เพราะมันอยู่ใน URL แล้ว
    };

    try {
      // อัปโหลดไฟล์และรับพาธของไฟล์
      var pathImg_Student = await uploadImages(img_student);

      data["img_student"] = pathImg_Student;

      var body = json.encode(data);

      var url = Uri.parse(baseURL + '/student/updateimage/${student_id}');
      http.Response response =
          await http.put(url, headers: headers, body: body);

      // ตรวจสอบสถานะ response
      if (response.statusCode == 200) {
        print("Update succeeded with status: ${response.statusCode}");
      } else {
        print("Failed to update with status: ${response.statusCode}");
      }

      return response;
    } catch (e) {
      print("An error occurred: $e");
      throw Exception("Failed to update student image");
    }
  }

  // Update Student Image
  // Future updateStudentImage(String student_id, File? img_student) async {
  //   if (img_student != null) {
  //     try {
  //       var url = Uri.parse(baseURL + '/student/updateimage/$student_id');
  //       var request = http.MultipartRequest('PUT', url);
  //       var stream = http.ByteStream(img_student.openRead());
  //       var length = await img_student.length();
  //       // request.headers.addAll(headers); // เพิ่ม headers ที่จำเป็น

  //       String fileExtension = img_student.path.split('.').last.toLowerCase();
  //       MediaType mediaType;

  //       if (fileExtension == 'png') {
  //         mediaType = MediaType('image', 'png');
  //       } else {
  //         mediaType = MediaType('image', 'jpg'); // กรณีเริ่มต้นเป็น jpg
  //       }

  //       var multipartFile = http.MultipartFile(
  //         'img_student', // ชื่อฟิลด์ที่เซิร์ฟเวอร์คาดหวัง
  //         stream,
  //         length,
  //         filename: img_student.path.split('/').last,
  //         contentType: mediaType,
  //       );
  //       request.files.add(multipartFile);

  //       // ส่ง request
  //       var response = await request.send();

  //       // ตรวจสอบสถานะ response
  //       if (response.statusCode == 200) {
  //         print("Update succeeded with status: ${response.statusCode}");
  //         var jsonResponse = await response.stream.bytesToString();
  //         return jsonResponse; // คืนค่าข้อมูล JSON ถ้าต้องการ
  //       } else {
  //         print("Failed to update with status: ${response.statusCode}");
  //         return null;
  //       }
  //     } catch (e) {
  //       print("An error occurred: $e");
  //       throw Exception("Failed to update student image");
  //     }
  //   }
  // }
}
