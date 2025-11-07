import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project_final/controller/OfficerController.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final OfficerController officerController = OfficerController();
  final StudentController studentController = StudentController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int _selectedUserTypeIndex = 0; // 0 for Officer, 1 for Student

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Khubdee MJU
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo_khubdee.png',
                      width: 250,
                    ),
                  ),
        
                  // ToggleButtons เลือกประเภทผู้ใช้
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: ToggleButtons(
                      key: ValueKey<int>(_selectedUserTypeIndex),
                      isSelected: [
                        0 == _selectedUserTypeIndex,
                        1 == _selectedUserTypeIndex
                      ],
                      onPressed: (int index) {
                        setState(() {
                          _selectedUserTypeIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Color(0xFF006D0D),
                      highlightColor: Colors.greenAccent.withOpacity(0.2),
                      borderColor: Color(0xFF006D0D),
                      selectedBorderColor: Color(0xFF006D0D),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('เจ้าหน้าที่', style: TextStyle(fontSize: 16, fontFamily: 'Mitr')),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('นักศึกษา', style: TextStyle(fontSize: 16, fontFamily: 'Mitr')),
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 8),
        
                  // Field email
                  textFieldName(emailController, 'อีเมล'),
        
                  SizedBox(height: 8),
        
                  // Field password
                  textFieldName(passwordController, 'รหัสผ่าน', isPassword: true),
        
                  SizedBox(height: 16),
        
                  // Signin button with icon
                  Container(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          http.Response response;
                          String userType = _selectedUserTypeIndex == 0 ? 'Officer' : 'Student';
        
                          if (userType == 'Officer') {
                            // ล็อกอิน Officer
                            response = await officerController.officerLogin(
                                emailController.text, passwordController.text);
                          } else {
                            // ล็อกอิน Student
                            response = await studentController.studentLogin(
                                emailController.text, passwordController.text);
                          }
        
                          if (response.statusCode == 200) {
                            // บันทึก session
                            await SessionManager().set("email", emailController.text);
                            await SessionManager().set("userType", userType);
        
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('เข้าสู่ระบบล้มเหลว', style: TextStyle(fontFamily: 'Mitr')),
                                  content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง', style: TextStyle(fontFamily: 'Mitr')),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ตกลง', style: TextStyle(fontFamily: 'Mitr')),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006D0D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login,
                            size: 24,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16, fontFamily: 'Mitr')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//สร้าง Widget เพื่อเรียกใช้ Field ที่เหมือนกันได้หลายครั้ง
Widget textFieldName(TextEditingController text, String name, {bool isPassword = false}) {
  bool _isObscure = true;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontFamily: 'Mitr'),
          ),
          Container(
            child: TextFormField(
              controller: text,
              obscureText: isPassword && _isObscure,
              validator: (value) {
                if (name == 'อีเมล') {
                  // Email validation regex
                  bool isValidEmail =
                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!);
                  if (value.isEmpty) {
                    return 'กรุณากรอก$name';
                  } else if (!isValidEmail) {
                    return '$nameไม่ถูกต้อง';
                  } else if (value.length <= 10 || value.length > 50) {
                    return '$nameต้องไม่เกิน 50 ตัวอักษร';
                  }
                } else {
                  // Password validation regex
                  bool isValidPassword =
                      RegExp(r'^(?=.*[0-9][a-z0-9]){2,20}').hasMatch(value!);
                  if (value.isEmpty) {
                    return 'กรุณากรอก$name';
                  } else if (!isValidPassword) {
                    return '$nameไม่ถูกต้อง';
                  } else if (value.length <= 4 || value.length >= 20) {
                    return '$nameต้องไม่เกิน 20 ตัวอักษร';
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: name,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 14,
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )
                    : null,
              ),
              style: TextStyle(
                color: Color(0xFF363636),
                fontSize: 14,
                fontFamily: 'Mitr',
              ),
            ),
          ),
        ],
      );
    },
  );
}

