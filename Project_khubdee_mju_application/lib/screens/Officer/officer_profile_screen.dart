import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project_final/controller/OfficerController.dart';
import 'package:project_final/model/officer.dart';
import 'package:project_final/screens/home_screen.dart';
import 'package:project_final/screens/login_screen.dart';
import 'package:project_final/constants/constant_value.dart';

class OfficerProfileScreen extends StatefulWidget {
  const OfficerProfileScreen({super.key});

  @override
  State<OfficerProfileScreen> createState() => _OfficerProfileScreenState();
}

class _OfficerProfileScreenState extends State<OfficerProfileScreen> {
  OfficerController officerController = OfficerController();

  String? email;
  Officer? officer;
  bool? isLoaded;


  @override
  void initState() {
    super.initState();
    fectData();
  }

  void fectData() async {
    var emailSession = await SessionManager().get("email");
    print("Email Storage: " + emailSession.toString());
    email = emailSession.toString();

    officer = await officerController.getOfficerByEmail(email ?? "");
    setState(() {
      isLoaded = true;
    });
  }

  void logout() async {
    await SessionManager().remove("email"); 
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen(); // Navigate to the login screen
      }),
    );
  }

  @override
  Widget build(BuildContext context) {

    // เพิ่มส่วนนี้เพื่อเรียกให้รูปภาพผ่าน URL ซึ่งใช้รูปที่มาจาก Folder: C:file:///C:/img/img_officer
    const String imageURL = baseURL + "/img_officer/";
    
    return Scaffold(
      appBar: AppBar(
        title:
            Text('บัญชี', style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'Mitr')),
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
                    // รูปภาพ
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
                              backgroundImage: NetworkImage('$imageURL${officer?.img_officer}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),

                    itemProfile("รหัสเจ้าหน้าที่ :", "${officer?.officer_id}",
                        Icons.badge_rounded),
                    SizedBox(height: 15.0),

                    itemProfile(
                        "ชื่อ-นามสกุล :",
                        "${officer?.firstname} ${officer?.lastname}",
                        Icons.person),
                    SizedBox(height: 15.0),

                    itemProfile(
                        "ตำแหน่ง :", "${officer?.position}", Icons.work),
                    SizedBox(height: 15.0),

                    itemProfile("อีเมล :", "${officer?.email}", Icons.mail),
                    SizedBox(height: 15.0),

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

  // Widget เพิ่มข้อมูล
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
        title: Text(title,style: TextStyle(fontFamily: 'Mitr')),
        subtitle: Text(subtitle),
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
                title: Text('ออกจากระบบ',style: TextStyle(fontFamily: 'Mitr')),
                content: Text('คุณต้องการออกจากระบบหรือไม่?',style: TextStyle(fontFamily: 'Mitr')),
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
                      child: Text('ยกเลิก',style: TextStyle(fontFamily: 'Mitr')),
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
                      child: Text('ตกลง',style: TextStyle(fontFamily: 'Mitr')),
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
                Text(
                  'ออกจากระบบ',
                  style: TextStyle(color: Colors.white,fontFamily: 'Mitr'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
