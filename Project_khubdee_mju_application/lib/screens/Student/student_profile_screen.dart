import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/screens/home_screen.dart';
import 'package:project_final/screens/login_screen.dart';
import 'package:project_final/constants/constant_value.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  StudentController studentController = StudentController();

  String? email;
  Student? student;
  bool? isLoaded;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // โหลดข้อมูลนักศึกษา
  void fetchData() async {
    var emailSession = await SessionManager().get("email");
    email = emailSession.toString();

    student = await studentController.getStudentByEmail(email ?? "");
    setState(() {
      isLoaded = true;
    });
  }

  // ฟังก์ชันออกจากระบบ
  void logout() async {
    await SessionManager().remove("email");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // เพิ่มส่วนนี้เพื่อเรียกให้รูปภาพผ่าน URL ซึ่งใช้รูปที่มาจาก Folder: C:file:///C:/img/img_student
    const String imageURL = baseURL + "/img_student/";

    return Scaffold(
      appBar: AppBar(
        title: Text('บัญชี',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Mitr')),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return HomeScreen();
            }));
          },
        ),
      ),
      body: isLoaded == true
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    // แสดงรูปภาพนักเรียนและปุ่มเพิ่มรูปภาพ
                    Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  '$imageURL${student?.img_student}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),

                    // ข้อมูลโปรไฟล์นักศึกษา
                    itemProfile("รหัสนักศึกษา :", "${student?.student_id}",
                        Icons.badge_rounded),
                    SizedBox(height: 15.0),
                    itemProfile(
                        "ชื่อ-นามสกุล :",
                        "${student?.firstname} ${student?.lastname}",
                        Icons.person),
                    SizedBox(height: 15.0),
                    itemProfile(
                        "คะแนนคงเหลือ :",
                        "${student?.student_score} " + "คะแนน ",
                        Icons.credit_score),
                    SizedBox(height: 15.0),
                    itemProfile("อีเมล :", "${student?.email}", Icons.mail),
                    SizedBox(height: 15.0),
                    itemProfile("สาขา :", "${student?.major}", Icons.book),
                    SizedBox(height: 15.0),
                    itemProfile("คณะ :", "${student?.faculty}", Icons.school),
                    SizedBox(height: 15.0),

                    // ปุ่ม Logout
                    onLogout(),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  // Widget เพิ่มข้อมูลโปรไฟล์นักศึกษา
  Widget itemProfile(String title, String subtitle, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Color(0xFF006D0D),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontFamily: 'Mitr')),
        subtitle: Text(subtitle, style: TextStyle(fontFamily: 'Mitr')),
        leading: Icon(icon),
        tileColor: Colors.white,
      ),
    );
  }

  // ปุ่ม Logout
  Widget onLogout() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ออกจากระบบ', style: TextStyle(fontFamily: 'Mitr')),
                content: Text('คุณต้องการออกจากระบบหรือไม่?',
                    style: TextStyle(fontFamily: 'Mitr')),
                actions: [
                  SizedBox(
                    width: 100, // Set the width of the button
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF627CFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          Text('ยกเลิก', style: TextStyle(fontFamily: 'Mitr')),
                    ),
                  ),
                  SizedBox(
                    width: 100, // Set the width of the button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        logout();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('ตกลง', style: TextStyle(fontFamily: 'Mitr')),
                    ),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50.0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white),
                SizedBox(width: 8.0),
                Text('ออกจากระบบ',
                    style: TextStyle(color: Colors.white, fontFamily: 'Mitr')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
