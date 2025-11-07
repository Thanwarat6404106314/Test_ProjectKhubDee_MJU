import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:project_final/controller/RecordViolationController.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/model/recordviolation.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/screens/Student/violation_detail_screen.dart';
import 'package:project_final/screens/home_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  StudentController studentController = StudentController();
  RecordViolationController recordViolationController =
      RecordViolationController();

  List<RecordViolation>? recordviolationList;
  String? email;
  Student? student;
  bool? isLoaded;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchDate();
  }

  void fetchDate() async {
    var emailSession = await SessionManager().get("email");
    email = emailSession.toString();

    student = await studentController.getStudentByEmail(email ?? "");
    setState(() {
      isLoaded = true;
    });

    try {
      if (student != null) {
        List<RecordViolation> RecViolation = await recordViolationController
            .getListRecordViolationByStudentID(student!.student_id.toString());
        setState(() {
          recordviolationList = RecViolation;
          isLoaded = true;
        });
      } else {
        setState(() {
          recordviolationList = [];
          isLoaded = true;
        });
      }
    } catch (e) {
      print('E: $e');
      setState(() {
        recordviolationList = [];
        isLoaded = true;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติข้อมูลนักศึกษา',
          style:
              TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Mitr'),
        ),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return HomeScreen();
              }),
            );
          },
        ),
      ),
      body: _selectedIndex == 0 ? QrCodeStudentScreen() : listViolationScreen(),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle:
            TextStyle(color: Colors.grey[400], fontFamily: 'Mitr'),
        unselectedLabelStyle: TextStyle(color: Colors.grey, fontFamily: 'Mitr'),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_outlined),
            label: 'คิวอาร์โค้ด',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp),
            label: 'ประวัติการละเมิดกฎจราจร',
          ),
        ],
        backgroundColor: Colors.grey[350],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF006D0D),
        unselectedItemColor: Color(0xFF008910),
        onTap: _onItemTapped,
      ),
    );
  }

// หน้า รายการละเมิดกฎจราจรของนักศึกษา
  listViolationScreen() {
    return Scaffold(
      body: isLoaded == true
          ? recordviolationList != null && recordviolationList!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'รายการละเมิดกฎจราจร',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Mitr',
                              ),
                            ),
                          ),
                          Divider(height: 1, color: Color(0xFFCACACA)),
                          SizedBox(height: 8),
                          Text(
                            'ทั้งหมด: ${recordviolationList!.length} รายการ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontFamily: 'Mitr',
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recordviolationList!.length,
                            itemBuilder: (context, index) {
                              final recordViolation =
                                  recordviolationList![index];
                              final recordDate = DateFormat('dd/MM/yyyy')
                                  .format(recordViolation.record_date ??
                                      DateTime.now());
                              final recordTime = DateFormat('HH:mm').format(
                                  recordViolation.record_date ??
                                      DateTime.now());

                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(8),
                                  title: Text(
                                    'ประเภทการละเมิด: ${recordViolation.violationType?.violation_name ?? "-"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Mitr',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'วันที่: ${recordDate}',
                                        style: TextStyle(
                                          fontFamily: 'Mitr',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'เวลา: ${recordTime} น.',
                                        style: TextStyle(
                                          fontFamily: 'Mitr',
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (recordViolation.status_type != null)
                                        Text(
                                          'สถานะ: ${recordViolation.status_type}',
                                          style: TextStyle(
                                            fontFamily: 'Mitr',
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViolationDetailScreen(
                                          recordViolation: recordViolation,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "ไม่พบข้อมูลการละเมิดกฎจราจร",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontFamily: 'Mitr',
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
          : Center(child: CircularProgressIndicator()),
    );
  }

  // หน้า QrCode นักศึกษา
  QrCodeStudentScreen() {
    return Scaffold(
      body: Center(
        child: isLoaded == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'ชื่อ-นามสกุล: ${student?.firstname} ${student?.lastname}',
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                      fontFamily: 'Mitr',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'รหัสนักศึกษา: ${student?.student_id}',
                    style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                      fontFamily: 'Mitr',
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: QrImageView(
                      data: "${student?.student_id}",
                      version: QrVersions.auto,
                      size: 190.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Scan QR Code for Student Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Mitr',
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
