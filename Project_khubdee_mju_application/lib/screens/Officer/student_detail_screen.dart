import 'package:flutter/material.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/screens/Officer/record_violation_screen.dart';
import 'package:project_final/widgets/customField/customTextField.dart';
import 'package:project_final/constants/constant_value.dart';

class StudentDetaillScreen extends StatefulWidget {
  final String student_id;

  const StudentDetaillScreen({super.key, required this.student_id});

  @override
  State<StudentDetaillScreen> createState() => _studentDetaillScreenState();
}

class _studentDetaillScreenState extends State<StudentDetaillScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StudentController studentController = StudentController();

  TextEditingController student_idController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController student_scoreController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController facultyController = TextEditingController();

  bool isDataLoaded = false; // เริ่มต้นเป็น false
  Student? student;

  void setData() async {
    student_idController.text = widget.student_id;
    firstnameController.text = student?.firstname ?? '';
    lastnameController.text = student?.lastname ?? '';
    student_scoreController.text = student?.student_score.toString() ?? '';
    majorController.text = student?.major ?? '';
    facultyController.text = student?.faculty ?? '';
  }

  void fetcData() async {
    var response = await studentController.getStudentById(widget.student_id);
    setState(() {
      student = response;
      setData();
      isDataLoaded = true; // เมื่อข้อมูลถูกโหลดเสร็จ
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  @override
  Widget build(BuildContext context) {
    // เพิ่มส่วนนี้เพื่อเรียกให้รูปภาพผ่าน URL ซึ่งใช้รูปที่มาจาก Folder: C:file:///C:/img/img_student
    const String imageURL = baseURL + "/img_student/";

    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลนักศึกษาที่ละเมิดกฎจราจร',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Mitr')),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Container(
              margin: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    student?.img_student != null
                        ? Container(
                            width: 100,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFC5C5C5)),
                              borderRadius: BorderRadius.circular(8), // มุมโค้งมน
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8), // ทำให้รูปมีมุมโค้ง
                              child: Image.network(
                                '$imageURL${student!.img_student}',
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFC5C5C5)),
                              borderRadius: BorderRadius.circular(8), 
                            ),
                            child: Icon(
                              Icons.person, 
                              size: 50, 
                              color: Colors.grey, 
                            ),
                          ),
                    SizedBox(height: 8),
                    // รหัสนักศึกษา
                    CustomTextField(
                        controller: student_idController,
                        labelText: 'รหัสนักศึกษา',
                        hintText: 'รหัสนักศึกษา',
                        errorText: '',
                        enabled: false),
                    SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              controller: firstnameController,
                              labelText: 'ชื่อ',
                              hintText: 'ชื่อ',
                              errorText: '',
                              enabled: false),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                              controller: lastnameController,
                              labelText: 'นามสกุล',
                              hintText: 'นามสกุล',
                              errorText: '',
                              enabled: false),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // คณะ
                    CustomTextField(
                        controller: facultyController,
                        labelText: 'คณะ',
                        hintText: 'คณะ',
                        errorText: '',
                        enabled: false),
                    SizedBox(height: 8),

                    // สาขา
                    CustomTextField(
                        controller: majorController,
                        labelText: 'สาขา',
                        hintText: 'สาขา',
                        errorText: '',
                        enabled: false),
                    SizedBox(height: 8),

                    // คะเเนนพฤติกรรม
                    CustomTextField(
                      controller: student_scoreController,
                      labelText: 'คะเเนนคงเหลือ',
                      hintText: 'คะเเนนพฤติกรรม',
                      errorText: '',
                      enabled: false,
                    ),

                    SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return RecordViolationScreen(
                                student_id: student_idController.text,
                              );
                            },
                          ));
                        },
                        child: Text(
                          'บันทึกข้อมูลการละเมิดกฎจราจร',
                          style: TextStyle(fontFamily: 'Mitr'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF006D0D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
